class dump_memory_contexts(gdb.Command):

    def __init__(self):
        super(dump_memory_contexts, self).__init__('dump_memory_contexts',
                                                   gdb.COMMAND_USER,
                                                   gdb.COMPLETE_SYMBOL)

    def invoke(self, argstr, from_tty):
        top = gdb.parse_and_eval('(AllocSetContext *) TopMemoryContext')
        self.show(top, '')

    def show(self, mcxt, indent):
        while mcxt:
            mcxt = gdb.parse_and_eval('(AllocSetContext *) {}'.format(mcxt))
            allocated = int(mcxt['currentAllocated'])
            header = mcxt['header']
            name = header['name']
            child = header['firstchild']
            if child or allocated > 0:
                print('{}{}: {}: {}'.format(indent, mcxt, name, allocated))
            else:
                print('{}{}: {}: {}'.format(indent, mcxt, name, allocated))
            self.show(child, indent + '  ')
            mcxt = header['nextchild']

dump_memory_contexts()

class dump_syscaches(gdb.Command):

    def __init__(self):
        super(dump_syscaches, self).__init__('dump_syscaches',
                                             gdb.COMMAND_USER,
                                             gdb.COMPLETE_SYMBOL)

    def invoke(self, argstr, from_tty):
        n = gdb.parse_and_eval('sizeof(SysCache) / sizeof(SysCache[0])')
        syscaches = gdb.parse_and_eval('SysCache')
        for i in range(n):
            syscache = syscaches[i]
            print('[{}]: nbuckets={} ntups={} relname={}'
                  .format(syscache['id'],
                          syscache['cc_nbuckets'],
                          syscache['cc_ntup'],
                          syscache['cc_relname']))

dump_syscaches()
