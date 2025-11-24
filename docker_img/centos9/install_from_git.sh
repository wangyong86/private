sudo yum install -y gcc-toolset-14

source /opt/rh/gcc-toolset-14/enable

# github may not be reachable, change if appropriate
sudo sh -c 'echo "140.82.113.4 github.com" >> /etc/hosts'

# vim depends on ncurses
sudo yum install -y readline-devel ncurses-devel perl-core xmlto asciidoc

cd
git clone git@github.com:vim/vim.git vim
cd vim && ./configure  && make -j && sudo make install
cd && rm -rf vim

sudo yum install -y readline-devel ncurses-devel

# pg_format depends on perl-core
git clone git@github.com:wangyong86/private.git 
cd private && sh setup

#pg_format tool
cd pgFormatter && perl Makefile.PL && make -j && sudo make -j install
cd

sudo ln -sf /usr/local/bin/vim /usr/bin/vi

git clone git@github.com:neovim/neovim.git
cd neovim && git co v0.11.5
rm -rf build/ && make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim" && \
make && sudo make install && \
echo "export PATH=\"$HOME/neovim/bin:$PATH\"" >>~/.bash_profile && source ~/.bash_profile

git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
