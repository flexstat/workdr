
#/bin/bash
apt -y update

apt -y install git

apt-get install -y build-essential zlib1g-dev libpcre3 libpcre3-dev uuid-dev gcc git wget curl libgd3 libgd-dev  libssl-dev

wget https://nginx.org/download/nginx-1.20.2.tar.gz

tar -xvf nginx-1.20.2.tar.gz

cd nginx-1.20.2

wget --no-check-certificate https://www.openssl.org/source/openssl-1.1.1d.tar.gz

tar -xvf  openssl-1.1.1d.tar.gz 
