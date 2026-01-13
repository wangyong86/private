# printer for List in gp

import gdb

class PList (gdb.Command):
    """Print struct List for Postgres"""

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
        list_type = list["type"]
        if list_type == 657 or list_type == 658:
            list_cell = list_head
            idx = 0
            while list_cell != 0:
                ptr = list_cell["data"]["int_value"]
                ptr_str = ptr.format_string()
                if target_idx < 0:
                    print("[%d] %s" % (idx, ptr_str))
                elif target_idx == idx:
                    target_str = "print %s" % (ptr_str)
                    gdb.execute(target_str)
                    break

                list_cell = list_cell["next"]
                idx = idx + 1
            return

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

# for new version of PG which struct defined like below
# typedef struct List
# {
#     NodeTag     type;           /* T_List, T_IntList, T_OidList, or T_XidList */
#     int         length;         /* number of elements currently present */
#     int         max_length;     /* allocated length of elements[] */
#     ListCell   *elements;       /* re-allocatable array of cells */
#     /* We may allocate some cells along with the List header: */
#     ListCell    initial_elements[FLEXIBLE_ARRAY_MEMBER];
#     /* If elements == initial_elements, it's not a separate allocation */
# } List;

class PEList (gdb.Command):
    """Print struct List for new version of Postgres"""

    def __init__(self):
        super(PEList, self).__init__("pelist", gdb.COMMAND_USER)

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

        elements = list["elements"]
        list_type = list["type"]
        if list_type == 657 or list_type == 658:
            list_cell = list_head
            idx = 0
            while list_cell != 0:
                ptr = list_cell["data"]["int_value"]
                ptr_str = ptr.format_string()
                if target_idx < 0:
                    print("[%d] %s" % (idx, ptr_str))
                elif target_idx == idx:
                    target_str = "print %s" % (ptr_str)
                    gdb.execute(target_str)
                    break

                list_cell = list_cell["next"]
                idx = idx + 1
            return

        node_type = gdb.lookup_type("Node")
        idx = 0
        length = list["length"]
        while idx < length:
            listcell = elements[idx]
            ptr = listcell["ptr_value"]
            ptr_str = ptr.format_string()
            node = ptr.reinterpret_cast(node_type.pointer())

            type_str = node["type"].format_string().replace("T_", "")
            if target_idx < 0:
                print("[%d] *((%s*)%s)" % (idx, type_str, ptr_str))
            elif target_idx == idx:
                target_str = "print *((%s*)%s)" % (type_str, ptr_str)
                gdb.execute(target_str)
                break
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
PEList()
PList()
