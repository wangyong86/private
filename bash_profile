# .bash_profile
#if [ -f ~/.bashrc ]; then
#    . ~/.bashrc
#fi

# supress perl locale warning
export LC_ALL=en_US.UTF-8

if [ -f /usr/local/bin/git ]; then
    alias git='/usr/local/bin/git'
fi

if [ -f /home/wy/vim/bin/vim ]; then
    export VIMDIR=/home/wy/vim
elif [ -f /usr/local/bin/vim ]; then
    export VIMDIR=/usr/local/
else
    export VIMDIR=/usr
fi

# host relate config
# mac book
if [ "$HOSTNAME" = wydev ]; then 
	export GPHOME=/home/wy/gpdb
	export GPSRC=~/matrixdb
# docker
elif [ "$HOSTNAME" = sdw1 ]; then
	export GPHOME=/workspace/gpdb
	export GPSRC=/workspace/matrixdb
#server
else 
	export GPHOME=/home/wy/gpdb
	export GPSRC=~/matrixdb
fi

# Setup matrixdb env
if [ -f $GPHOME/greenplum_path.sh ]; then
    source $GPHOME/greenplum_path.sh
fi

export GPDEMO=$GPSRC/gpAux/gpdemo/
if [ -f $GPDEMO/gpdemo-env.sh ]; then
    source $GPDEMO/gpdemo-env.sh
fi
export RTPATH=$GPSRC/src/test/regress
export CPATH=$GPSRC/contrib

export PATH=/opt/MegaRAID/MegaCli/:$HOME/install/bin:$TSBS/bin:$GIT:$PATH:$LLVM/build/bin:$GPHOME/sbin:$GPHOME/bin:$HOME/private/exec/:$GPSRC/:$REGRESS_TEST_PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/lib64

# tool modify
alias tmux="tmux -u -2"
alias gti="git"
alias vim="$VIMDIR/bin/vim -O"
alias vi="vim"
alias gdb="gdb -q"
alias srb="source ~/.bash_profile"

# utility path
alias ctest="cd ~/private/test"
alias prd="cd ~/private"
alias pr="prd; vi "
alias vt="vi ~/private/exec/mytool"
alias ppi="pp -i"
alias ppd="pp -d"

# third party path
source ~/private/bash_dynamic_alias

# command compound
alias src="source $GPHOME/greenplum_path.sh;source $GPDEMO/gpdemo-env.sh"
alias g11="source /opt/rh/devtoolset-11/enable"
alias g10="source /opt/rh/devtoolset-10/enable"
alias g9="source /opt/rh/devtoolset-9/enable"
alias g8="source /opt/rh/devtoolset-8/enable"
alias g7="source /opt/rh/devtoolset-7/enable"

alias xmake="compiledb make"
alias ftime='/usr/bin/time -f "\n---------------------------------\nElapseTime(m:s):\t"%E"\nKernelTime(s):\t"%S"\nUserTime(s):\t"%U"\nCPUPercentage:\t"%P"\nMaxResidnetMem(Kb):\t"%M"\nAvgDataMem(Kb):\t"%D"\nInvolCS:\t"%c"\nVolCS:\t"%w"\nFsInput:\t"%I"\nFsOuput:\t"%O"\nSkRcv:\t"%r"\nSkSnd:\t"%s'

alias psql='psql -P pager=off -v ECHO=all'

# Database
export PGDATABASE=t

export CC="ccache gcc"

export CPP="ccache cpp"

export CXX="ccache g++"

# For tmux, it may incur unknown env change at very early stage(before loading
# /etc/profile
#unset CC; unset CXX

#use gcc as high as possible, gcc7 is smallest one
if [ -f /opt/rh/devtoolset-10/enable ]; then
	source /opt/rh/devtoolset-10/enable
elif [ -f /opt/rh/devtoolset-11/enable ]; then
	source /opt/rh/devtoolset-11/enable
elif [ -f /opt/rh/devtoolset-7/enable ]; then
	source /opt/rh/devtoolset-7/enable
fi

