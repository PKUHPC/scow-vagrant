#!/bin/sh

db_passwd="81SLURM@@rabGTjN7"
# 安装mariadb
yum -y install mariadb-server
systemctl start mariadb
systemctl enable mariadb

# 初始化
mysql << EOF
   set password=password('${db_passwd}');
   create database slurm_acct_db;
   create user slurm;
   grant all on slurm_acct_db.* TO 'slurm'@'localhost' identified by '123456' with grant option;
   flush privileges;
EOF







