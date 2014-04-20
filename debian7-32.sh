# http://git.io/n4OFcg
 
#date > /etc/vagrant_box_build_time
 
#echo 'ubuntu-saucy.vagrant' > /etc/hostname
#echo '127.0.0.1 ubuntu-saucy.vagrant' >> /etc/hosts
#start hostname
 
apt-get -y update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r) build-essential

#apt-get -y install zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev
#apt-get -y install vim
#apt-get -y install dkms
#apt-get -y install nfs-common
apt-get clean
