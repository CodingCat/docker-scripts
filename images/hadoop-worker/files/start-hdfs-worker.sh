#!/bin/bash

# start the hdfs master node
DATANODES=`hostname`

# passwordless ssh login

function create_hadoop_directories() {
    rm -rf /root/.ssh
    mkdir /root/.ssh
    chmod go-rx /root/.ssh
    mkdir /var/run/sshd
}

function deploy_hadoop_files() {
    ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
    cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
}

create_hadoop_directories
deploy_hadoop_files

service ssh start

echo "Starting datanode on worker"

"$HADOOP_PREFIX/sbin/hadoop-daemons.sh" \
  --config "$HADOOP_CONF_DIR" \
  --hostnames "$DATANODES" \
  --script "$HADOOP_PREFIX/bin/hdfs" start datanode $dataStartOpt

while [ 1 ];
do
    sleep 3
done
