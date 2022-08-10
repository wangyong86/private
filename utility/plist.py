# printer for List in gp

import gdb


class PList (gdb.Command):
    """Print struct List for gp"""

    def __init__(self):
        super(PList, self).__init__("plist", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        args = arg.split()

        target_idx = -1
        target_str = None
        if len(args) > 1:
            target_idx = int(args[1])

        list = gdb.parse_and_eval(args[0])
        if list.is_optimized_out:
            print("node %s is optimized out" % args[0])
            return
        list_head = list["head"]

        node_type = gdb.lookup_type("Node")
        list_cell = list_head
        idx = 0
        while list_cell != 0:
            ptr = list_cell["data"]["ptr_value"]
            ptr_str = ptr.format_string()
            node = ptr.reinterpret_cast(node_type.pointer())

            type_str = node["type"].format_string().replace("T_", "")
            if target_idx < 0:
                print("[%d] *((%s*)%s)" % (idx, type_str, ptr_str))
            elif target_idx == idx:
                target_str = "print *((%s*)%s)" % (type_str, ptr_str)
                gdb.execute(target_str)
                break

            list_cell = list_cell["next"]
            idx = idx + 1


class PNode (gdb.Command):
    """Print any node for gp"""

    def __init__(self):
        super(PNode, self).__init__("pnode", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        val_ptr = gdb.parse_and_eval(arg)
        if val_ptr.is_optimized_out:
            print("node %s is optimized out" % arg)
            return

        base_node_type = gdb.lookup_type("Node")
        node_ptr = val_ptr.reinterpret_cast(base_node_type.pointer())

        type_str = node_ptr["type"].format_string().replace("T_", "")
        val_ptr_str = val_ptr.format_string()

        target_str = "print *((%s*)%s)" % (type_str, val_ptr)
        gdb.execute(target_str)


PNode()
PList()
