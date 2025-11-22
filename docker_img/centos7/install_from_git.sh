
source /opt/rh/devtoolset-10/enable

# github may not be reachable, change if appropriate
sudo sh -c 'echo "140.82.113.4 github.com" >> /etc/hosts'

# vim depends on ncurses
sudo yum install -y readline-devel ncurses-devel perl-core xmlto asciidoc

cd
git clone git@github.com:vim/vim.git vim
cd vim && ./configure  && make -j && sudo make install
cd && rm -rf vim

# git depends on ncurses
git clone git@github.com:git/git.git git
cd git && git checkout v2.44.0 && make configure && ./configure && make -j && make -j doc && sudo make install install-doc
#cd && rm -rf git

sudo yum install -y readline-devel ncurses-devel

# cgdb depends on ncurses and readline
git clone git@github.com:cgdb/cgdb.git cgdb
cd cgdb && sh autogen.sh && ./configure && make -j && sudo make install
cd && rm -rf cgdb

# pg_format depends on perl-core
git clone git@github.com:wangyong86/private.git 
cd private && sh setup

#pg_format tool
cd pgFormatter && perl Makefile.PL && make -j && sudo make -j install
cd

sudo ln -sf /usr/local/bin/git /usr/bin/git
sudo ln -sf /usr/local/bin/vim /usr/bin/vi
