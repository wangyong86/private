# disable promt when quit
set confirm off

set history filename ~/.gdb_history
set history save on

# print as derived type
set print object on
set print pretty on

# display
set tui tab-width 4

# ignore signal, may use noprint option
handle SIGUSR1 nostop

source ~/private/utility/plist.py
source ~/private/utility/dump.py
