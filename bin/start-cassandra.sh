#!/bin/bash

. bin/env.sh

NODE_NUM=$1

source $SCRIPT_HOME/bin/start-nameserver.sh

function start_cassandra_node() {
  echo "starting worker containers"
  for i in `seq 1 $NODE_NUM`; do
        echo "starting worker container"
        hostname="worker${i}"
        #create work dir
        mkdir -p /Users/nanzhu/code/docker/fs/cassandra/$hostname
        WORKER=$(docker run -d -t -i --dns $NAMESERVER_IP -h $hostname -v  $LOCAL_FS_HOME/cassandra/$hostname:/mnt/sda1/cassandra  $1:$2 /root/cassandra/start-cassandra-node.sh)
        if [ "$WORKER" = "" ]; then
            echo "error: could not start node container from image $1:$2"
            exit 1
        fi

        echo "started node container:  $WORKER"
        sleep 3
        NODE_IP=$(docker inspect $WORKER 2>&1 | grep -oEi "\"IPAddress\": \"([0-9]{1,3}[\.]){3}[0-9]{1,3}\"" | grep -oEi "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
        echo "address=\"/$hostname/$NODE_IP\"" >> $DNSFILE
        # add reverse dns record
        reverse_ip $NODE_IP
        echo "ptr-record=$REVERSED_IP.in-addr.arpa,$hostname" >> $DNSFILE
  done
}

start_nameserver codingcat/dev:nameserver
wait_for_nameserver
start_cassandra_node codingcat/dev cassandra
