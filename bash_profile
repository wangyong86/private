# .bash_profile

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -f /opt/rh/devtoolset-7/enable ]; then
    . /opt/rh/devtoolset-7/enable
fi

# host relate config
# mac book
if [ "$HOSTNAME" = wydev ]; then 
	export GPHOME=/home/wy/gpdb
	export GPSRC=~/matrixdb
	export GIT=/home/wy/git-2.12.4
#server
else 
	export GPHOME=/data1/wy64/gpdb64
	export GPSRC=~/matrixdb
fi

#export GPHOME=/home/wy/temp/usr/local/matrixdb-4.3.0.community
#export GPHOME=/home/wy/gpdb64
#export GPSRC=~/64matrixdb

if [ -f $GPHOME/greenplum_path.sh ]; then
    source $GPHOME/greenplum_path.sh
fi

if [ -f $GPDEMO/gpdemo-env.sh ]; then
    source $GPDEMO/gpdemo-env.sh
fi

# User specific environment and startup programs

#PATH=$PATH:$HOME/.local/bin:$HOME/bin:$GPHOME/bin:$HOME/exec/


# supress perl locale warning
#export LC_ALL=C
export LC_ALL=en_US.UTF-8
#export LANGUAGE=en_US.UTF-8

export CLICKSRC=~/ClickHouse
export GPDEMO=$GPSRC/gpAux/gpdemo/
export LLVM=/home/wy/llvm-project
export DD=$GPDEMO/datadirs
export RTPATH=$GPSRC/src/test/regress
export MPATH=$GPSRC/contrib/mars
export TSBS=/home/wy/tsbs
export FAST=/home/wy/superfast

export PATH=$TSBS/bin:$GIT:$PATH:$LLVM/build/bin:$GPHOME/bin:$HOME/private/exec/:$GPSRC/:$REGRESS_TEST_PATH
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/lib64

#for source compiled arrow
#export PKG_CONFIG_PATHl=$PKG_CONFIG_PATHl:/usr/local/lib64/pkgconfig

#tool modify
alias tmux="tmux -u"
alias gti="git"
alias vim="/usr/bin/vim -O"
alias vi="vim"
alias vt="vi ~/private/exec/mytool"
alias gdb="gdb -q"
alias srb="source ~/.bash_profile"

#utility path
alias gpdb="cd $GPHOME/bin/"
alias dd="cd $DD"
alias ctest="cd ~/private/test"
alias pr="cd ~/private"
alias fast="cd ~/libsuperfast"
alias ppi="pp -i"
alias ppd="pp -d"

#source coce path
alias code="cd $GPSRC"
alias fast="cd $FAST"
alias plan="cd $GPSRC/src/backend/optimizer/plan/"
alias ctor="cd $GPSRC/src/backend/executor/"
alias access="cd $GPSRC/src/backend/access/"
alias ctlg="cd $GPSRC/src/backend/catalog"
alias mars="cd $MPATH"
alias rt="cd $RTPATH"

alias ccode="cd $CLICKSRC"
alias tsbs="cd /home/wy/tsbs"

# command compound
alias src="source $GPHOME/greenplum_path.sh;source $GPDEMO/gpdemo-env.sh"
alias mkmars="mars && make clean && CFLAGS='-O0 -g3' CXXFLAGS='-O0 -g3' make -j7 CXX=/usr/bin/g++"
