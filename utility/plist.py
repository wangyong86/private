# printer for PostgreSQL/GPDB List and Node values
#
# This file is a small gdb Python extension.  gdb loads it with:
#   source /home/wy/private/utility/plist.py
# and the command objects instantiated at the bottom register `plist`,
# `pelist`, and `pnode` in the current gdb session.
#
# The main design goal is compatibility:
# - old PostgreSQL/GPDB linked-list layout: List.head -> ListCell.next
# - PostgreSQL 18 array layout: List.elements[idx]
#
# The implementation therefore avoids version-specific branches whenever
# possible and instead detects the available fields from debug info.

import gdb


def _field_names(gdb_type):
    # Use debug-info introspection instead of hard-coded version checks.
    # In gdb Python, `fields()` exposes the current struct/union layout, which
    # lets the script decide at runtime whether it is looking at an old or new
    # PostgreSQL List representation.
    return {field.name for field in gdb_type.strip_typedefs().fields() if field.name}


def _as_struct_value(value):
    # gdb expressions may produce either a pointer or a by-value struct.
    # Normalize them so the rest of the code can work on a struct-like object.
    value_type = value.type.strip_typedefs()
    if value_type.code == gdb.TYPE_CODE_PTR:
        if int(value) == 0:
            return None
        return value.dereference()
    return value


def _node_tag_name(tag_value):
    # PostgreSQL node tags are printed by gdb as enums such as `T_Query`.
    # Strip the common prefix so we can build a cast expression like:
    #   print *((Query*)0x...)
    return str(tag_value).replace("T_", "")


class _ListPrinter(object):
    def __init__(self):
        # Cache runtime-resolved types/tags after the first real command use.
        # This is intentionally lazy: if the file is auto-sourced from
        # `.gdbinit`, eager `lookup_type("Node")` can fail before PostgreSQL
        # symbols are fully available in the inferior.
        self.node_type = None
        self.list_kind_names = None

    def _ensure_types(self):
        if self.node_type is not None and self.list_kind_names is not None:
            return

        # Resolve symbols only on first real command use.  This is the concrete
        # lazy-loading pattern in this file: `source plist.py` should succeed even
        # if PostgreSQL symbols are not yet fully available, while the first real
        # `plist` invocation is allowed to require them.
        #
        # `lookup_type("Node")` asks gdb for the C type object of PostgreSQL's
        # base Node struct.  Later we reinterpret pointer-list elements as
        # `Node *`, inspect the common `type` tag, and print them as the concrete
        # node type such as `Query`, `RawStmt`, etc.
        self.node_type = gdb.lookup_type("Node")
        #
        # `parse_and_eval("T_*List")` asks gdb to evaluate the enum constants from
        # the inferior's own symbols, then `int(...)` converts the resulting
        # gdb.Value into a Python integer.  We intentionally do this at runtime
        # instead of hard-coding NodeTag numbers because different PostgreSQL
        # versions/forks may assign different numeric values.
        #
        # The resulting map is: actual NodeTag value -> scalar payload kind.
        # Later, when `list_value["type"]` matches one of these tags, the script
        # knows it should read `int_value`, `oid_value`, or `xid_value` instead of
        # treating the list as a pointer list.
        self.list_kind_names = {
            int(gdb.parse_and_eval("T_IntList")): "int",
            int(gdb.parse_and_eval("T_OidList")): "oid",
        }
        #
        # `T_XidList` is optional across versions/forks.  Treat it as a best-
        # effort extension: if the symbol exists, support xid lists; if not,
        # keep `plist` usable for ordinary List/IntList/OidList instead of
        # failing the whole command.
        try:
            self.list_kind_names[int(gdb.parse_and_eval("T_XidList"))] = "xid"
        except gdb.error:
            pass

    def _parse_args(self, arg):
        # `gdb.string_to_argv` gives shell-like argument splitting and matches
        # how normal gdb commands parse `plist expr [index]`.
        args = gdb.string_to_argv(arg)
        if not args:
            raise gdb.GdbError("usage: plist LIST_EXPR [INDEX]")

        target_idx = -1
        if len(args) > 1:
            target_idx = int(args[1])
        return args[0], target_idx

    def _get_list(self, expr):
        # Evaluate the user expression in the current frame, then normalize it
        # to a struct value.  This keeps the user-facing command flexible:
        # callers can pass either `foo`, `foo->bar`, or any valid gdb expr.
        value = gdb.parse_and_eval(expr)
        if value.is_optimized_out:
            raise gdb.GdbError("node %s is optimized out" % expr)

        list_value = _as_struct_value(value)
        if list_value is None:
            return None

        if list_value.is_optimized_out:
            raise gdb.GdbError("node %s is optimized out" % expr)
        return list_value

    def _scalar_kind(self, list_value):
        # PostgreSQL uses distinct NodeTag values for pointer lists vs scalar
        # lists (IntList, OidList, XidList).  Resolve them at runtime so the
        # script stays robust across branches where enum numbers may differ.
        self._ensure_types()
        return self.list_kind_names.get(int(list_value["type"]))

    def _cell_payload(self, cell):
        # Old layouts store payload under `cell.data.xxx_value`.
        # PG18's ListCell is a union whose members are directly on the cell.
        # Detecting the presence of `data` lets one implementation handle both.
        cell_value = _as_struct_value(cell)
        if cell_value is None:
            return None

        cell_fields = _field_names(cell_value.type)
        if "data" in cell_fields:
            return cell_value["data"]
        return cell_value

    def _iter_linked(self, list_value):
        # Legacy/GPDB layout: follow `head` / `next`.
        cell = list_value["head"]
        while int(cell) != 0:
            yield self._cell_payload(cell)
            cell = cell["next"]

    def _iter_array(self, list_value):
        # PostgreSQL 18 layout: iterate the materialized cell array.
        elements = list_value["elements"]
        length = int(list_value["length"])
        for idx in range(length):
            yield self._cell_payload(elements[idx])

    def _iter_cells(self, list_value):
        # Structural detection is the central compatibility trick in this file.
        # Prefer checking for fields from debug info over checking a server
        # version, because the script may be used across forks/backports.
        list_fields = _field_names(list_value.type)
        if "elements" in list_fields and "length" in list_fields:
            return self._iter_array(list_value)
        if "head" in list_fields:
            return self._iter_linked(list_value)
        raise gdb.GdbError("unsupported List layout: %s" % list_value.type)

    def _print_scalar(self, idx, cell_value, kind, target_idx):
        # The command has two output modes:
        # - no index: print a compact one-line summary for each element
        # - with index: delegate to gdb's normal `print` for a deep inspection
        # Returning True tells the caller that the requested element was found.
        field_name = "%s_value" % kind
        scalar = cell_value[field_name]
        if target_idx < 0:
            print("[%d] %s" % (idx, scalar.format_string()))
        elif target_idx == idx:
            gdb.execute("print %s" % scalar.format_string())
            return True
        return False

    def _print_node(self, idx, cell_value, target_idx):
        # For pointer lists, reinterpret the payload as `Node *`, read its tag,
        # and then build a more precise cast for gdb.  This preserves the old
        # `plist` user experience: first show a concise type summary, then allow
        # `plist expr N` to print the concrete node structure.
        self._ensure_types()
        ptr = cell_value["ptr_value"]
        ptr_str = ptr.format_string()
        node = ptr.reinterpret_cast(self.node_type.pointer())
        type_str = _node_tag_name(node["type"])

        if target_idx < 0:
            print("[%d] *((%s*)%s)" % (idx, type_str, ptr_str))
        elif target_idx == idx:
            gdb.execute("print *((%s*)%s)" % (type_str, ptr_str))
            return True
        return False

    def print_list(self, expr, target_idx):
        # The outer loop is intentionally shared by all layouts and list kinds;
        # only iteration and element decoding vary.  This keeps the command
        # behavior stable across old and new PostgreSQL versions.
        list_value = self._get_list(expr)
        if list_value is None:
            print("%s = NIL" % expr)
            return

        scalar_kind = self._scalar_kind(list_value)
        for idx, cell_value in enumerate(self._iter_cells(list_value)):
            if scalar_kind:
                if self._print_scalar(idx, cell_value, scalar_kind, target_idx):
                    return
            else:
                if self._print_node(idx, cell_value, target_idx):
                    return

        if target_idx >= 0:
            raise gdb.GdbError("list index %d out of range" % target_idx)


class PList(gdb.Command):
    """Print PostgreSQL List for both old linked-list and PG18 array layouts"""

    def __init__(self, command_name):
        # Subclassing `gdb.Command` is the standard way to add custom commands.
        # Constructing the object registers `command_name` immediately.
        super(PList, self).__init__(command_name, gdb.COMMAND_USER)
        self.printer = _ListPrinter()

    def invoke(self, arg, from_tty):
        # `invoke` is the gdb entry point for a custom command.
        expr, target_idx = self.printer._parse_args(arg)
        self.printer.print_list(expr, target_idx)


class PNode(gdb.Command):
    """Print any PostgreSQL Node pointer"""

    def __init__(self):
        super(PNode, self).__init__("pnode", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        # `pnode` is a smaller companion command that prints one Node pointer
        # directly, reusing the same runtime type discovery approach.
        val_ptr = gdb.parse_and_eval(arg)
        if val_ptr.is_optimized_out:
            print("node %s is optimized out" % arg)
            return

        base_node_type = gdb.lookup_type("Node")
        node_ptr = val_ptr.reinterpret_cast(base_node_type.pointer())
        type_str = _node_tag_name(node_ptr["type"])

        gdb.execute("print *((%s*)%s)" % (type_str, val_ptr.format_string()))


# Register commands when the file is sourced.
# `pelist` is kept as a backward-compatible alias to the same implementation.
PNode()
PList("plist")
PList("pelist")
