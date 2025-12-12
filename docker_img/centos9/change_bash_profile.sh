#!/bin/bash
echo "export RUSTUP_DIST_SERVER=\"https://rsproxy.cn\"" >> ~/.bash_profile
echo "export RUSTUP_UPDATE_ROOT=\"https://rsproxy.cn/rustup\"" >> ~/.bash_profile
echo "alias ls='ls --color=auto'" >> ~/.bash_profile
echo "alias ll='ls -l'" >> ~/.bash_profile
echo "alias ll='ls -l'" >> ~/.bash_profile

# timezone
sudo cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 24hour
echo "export LANG=en_US.utf8" >> ~/.bash_profile
echo "export LC_TIME=C" >> ~/.bash_profile
