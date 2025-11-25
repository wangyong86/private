#!/bin/bash
set -x

if [ $# -lt 2 ]; then
    echo "Usage: create_docker.sh $dockername $port "
    exit -1
fi

dockername=$1
port=$2
workdir=/home/wy/data/
container_name=${dockername}

# Stop and clean up existing wydev_arm
docker stop $container_name || true
docker rm $container_name || true
mkdir $workdir || true
sleep 1

# Backup files for wydev_arm
#if [ -d "$workdir" ]; then
#    mkdir -p "$workdir_bk" || true
#    sudo mv "$workdir"/* "workspace_dev1_bk/" || true
#    echo "Backed up contents of '$workdir' to 'workspace_dev1_bk'"
#fi

# Container creation and configuration
image_name="centos9-devsrv:v1"
#image_name="centos9-server:v1"
#image_name="docker.1ms.run/rockylinux/rockylinux:9-ubi-init"
#image_name="rockylinux/rockylinux:9-ubi-init"
#image_name="cr.kylinos.cn/kylin/kylin-server-v10sp3-aarch64:20230324"

container_network="compute"
container_ip="192.168.100.3"
#container_cpu="8"
container_memory="32g"
container_tmpfs_size="4G"
sudo docker rm $container_name
sudo docker run -d --name $container_name \
           -v $workdir:/workspace \
           -w /workspace \
           -e "USER=wy" \
           --cap-add=SYS_PTRACE \
           --cap-add=SYS_ADMIN \
           --hostname="sdw1"\
           --privileged \
           --tmpfs="/dev/shm:rw,size=$container_tmpfs_size" \
           -p $port:22 \
           $image_name  \
           /bin/sh -c 'while true; do sleep 1; done'
           #which sshd /usr/sbin/sshd -D

#           -e "USER=gpadmin" \
#           --tmpfs="/dev/shm:rw,size=$container_tmpfs_size" \
#           --cpus $container_cpu --memory $container_memory \
#           --network=$container_network \
#           --ip=$container_ip \
