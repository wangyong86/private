import gdb

class dump_memory_contexts(gdb.Command):
    "dump_memory_contestsssss"

    def __init__(self):
        super(dump_memory_contexts, self).__init__('dump_memory_contexts', gdb.COMMAND_USER, gdb.COMPLETE_SYMBOL)

    def invoke(self, argstr, from_tty):
        top = gdb.parse_and_eval('(AllocSetContext *) TopMemoryContext')
        self.show(top, '')

    def show(self, mcxt, indent):
        while mcxt:
            mcxt = gdb.parse_and_eval('(AllocSetContext *) {}'.format(mcxt))
            header = mcxt['header']
            name = header['name']
            allocated = int(header['mem_allocated'])
            child = header['firstchild']

            if child or allocated > 0:
                print('{}{}: {}: {}'.format(indent, mcxt, name, allocated))
            else:
                print('{}{}: {}: {}'.format(indent, mcxt, name, allocated))

            self.show(child, indent + '  ')
            mcxt = header['nextchild']

dump_memory_contexts()

class dump_block(gdb.Command):
    "dump_mcxt_block"

    def __init__(self):
        super(dump_block, self).__init__('dump_mcxt_block', gdb.COMMAND_USER, gdb.COMPLETE_SYMBOL)

    def invoke(self, argstr, from_tty):
        blk = gdb.parse_and_eval('(AllocBlock) {}'.format(argstr))
        self.printblock(blk, '')
    
    def printblock(self, blk, indent):
        blk_nr = 0
        while blk:
            #print('block: {} {}'.format(blk_nr, blk))
            
            endptr = gdb.parse_and_eval('(void*)((AllocBlock){})->endptr'.format(blk))
            blksz = gdb.parse_and_eval('(void*){} - (void*){}'.format(endptr, blk))
            print('block:{}, addr:{}, size={}'.format(blk_nr, blk, blksz))
            lst = gdb.parse_and_eval('(AllocChunk) ((char *){} + 40)'.format(blk))
            size = lst['size']
            aset = lst['aset']
            print('   firstchunksize:{}, aset={}'.format(size, aset))
            #lst = lst['next']
            #self.printlist(lst, '   ')
            blk = blk['next']
            blk_nr = blk_nr + 1

    def printlist(self, lst, indent):
        while lst:
            size = lst['size']
            aset = lst['aset']
            print('{}size={} aset={}'.format(indent, size, aset))
            lst = lst['next']

dump_block()
