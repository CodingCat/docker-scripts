#!/bin/bash

# start the hdfs master node
NAMENODES=master

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

echo "Starting namenode on master"

"$HADOOP_PREFIX/sbin/hadoop-daemons.sh" \
  --config "$HADOOP_CONF_DIR" \
  --hostnames "$NAMENODES" \
  --script "$HADOOP_PREFIX/bin/hdfs" start namenode $nameStartOpt

echo "Starting HMaster on master"

$HBASE_PREFIX/bin/hbase-daemons.sh --config "${HBASE_CONF_DIR}" start zookeeper

$HBASE_PREFIX/bin/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start master

while [ 1 ];
do
  sleep 3
done
