#!/bin/env bash
sudo groupadd -r minio-user
sudo useradd -m -r -g minio-user minio-user
#sudo chown minio-user:minio-user /mnt/data/minio

mkdir $HOME/.minio/certs -p
localbin=$HOME/.local/bin
mkdir $localbin -p

arch=$(uname -m)
if [ x"$arch" = xaarch64 ]; then
	srv_path=https://dl.min.io/server/minio/release/linux-arm64/archive/minio-20250907161309.0.0-1.aarch64.rpm
	clnt_path=https://dl.min.io/client/mc/release/linux-arm64/mc
elif [ x"$arch" = xx86-64 ]; then
	srv_path=https://dl.min.io/server/minio/release/linux-amd64/archive/minio-20231106222608.0.0.x86-64.rpm
	clnt_path=https://dl.min.io/client/mc/release/linux-amd64/mc
else
	echo "Unsupported arch: ${arch}\n"
fi
wget $srv_path -O minio.rpm
sudo dnf install minio.rpm -y
curl $clnt_path --create-dirs -o $localbin/mc
chmod +x $localbin/mc
