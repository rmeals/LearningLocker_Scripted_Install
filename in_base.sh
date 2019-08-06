
#######################################
#   Standard Updates and Linux Prep   #
#######################################

yum -y update
yum -y install git nano gcc gcc-c++ curl wget  

#######################################
#   Download and install NodeJS 8.x   #
#######################################

curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
yum -y install nodejs

systemctl start node
systemctl enable node
alias nodejs='/usr/bin/node'

#######################################
#    Prepare system & install Yarn    #
#######################################

yum -y install gcc-c++ make
yum -y install yarn

#######################################
#   Turn off transparent Huge Pages   #
#######################################

echo never > /sys/kernel/mm/transparent_hugepage/enabled

mkdir /etc/no-thp
mkdir /etc/tuned/no-thp
touch /etc/tuned/no-thp/tuned.conf

sed -i "s/enabled=1/enabled=0/" /etc/tuned/no-thp/tuned.conf

cat > /etc/tuned/no-thp/tuned.conf <<EOF
[main]
include=virtual-guest

[vm]
transparent_hugepages=never
EOF

tuned-adm profile no-thp

#######################################
#      Download and install Nginx     #
#######################################

sed -i "s/enabled=1/enabled=0/" /etc/yum.repos.d/nginx.repo

# Create a file with the "here document" feature
cat > /etc/yum.repos.d/nginx.repo <<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/x86_64/
gpgcheck=0
enabled=1
EOF


yum -y install nginx
systemctl start nginx
systemctl enable nginx
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload

#######################################
#  Install and configure Mongo DB 3.2 #
#######################################

sed -i "s/enabled=1/enabled=0/" /etc/yum.repos.d/mongodb-org-3.2.repo

cat > /etc/yum.repos.d/mongodb-org-3.2.repo <<EOF
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc
EOF

yum -y install mongodb-org

systemctl start mongod
systemctl enable mongod

echo 'mongod soft nproc 64000' >> /etc/security/limits.conf
echo 'mongod hard nproc 64000' >> /etc/security/limits.conf
echo 'mongod soft nofile 64000' >> /etc/security/limits.conf
echo 'mongod hard nofile 64000' >> /etc/security/limits.conf

systemctl restart mongod

#######################################
#     Install and configure Redis     #
#######################################

yum -y groupinstall "Development Tools"

wget -c http://download.redis.io/redis-stable.tar.gz
tar -xvzf redis-stable.tar.gz
cd redis-stable
make 
make test
sudo make install

mkdir /etc/redis
mkdir -p /var/redis/

cp redis.conf /etc/redis/

#is there a need to change default settings??

touch /etc/systemd/system/redis.service

sed -i "s/enabled=1/enabled=0/" /etc/systemd/system/redis.service

cat > /etc/systemd/system/redis.service <<EOF
[Unit]
Description=Redis In-Memory Data Store
After=network.target
[Service]
User=root
Group=root
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always
Type=Forking
[Install]
WantedBy=multi-user.target
EOF

systemctl start redis
systemctl enable redis
systemctl status redis

#######################################
#       Install Process Manager       #
#######################################

npm install pm2@latest -g
yum -y update

curl -o- -L http://lrnloc.kr/installv2 > /usr/share/nginx/html/deployll.sh
chmod 755 /usr/share/nginx/html/deployll.sh
cd /usr/share/nginx/html/

