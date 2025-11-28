# cgdb depends on ncurses and readline
git clone git@github.com:cgdb/cgdb.git cgdb
cd cgdb && sh autogen.sh && ./configure && make -j && sudo make install
cd && rm -rf cgdb
