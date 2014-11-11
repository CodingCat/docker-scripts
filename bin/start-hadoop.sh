#!/bin/bash
#Start HDFS service in multiple containers

BASEDIR=$(cd $(dirname $0); pwd)

MASTER=-1
MASTER_IP=

WORKER_NUM=$1

source $BASEDIR/start-nameserver.sh

# starts the HDFS master container
function start_master() {
    echo "starting master container"
    MASTER=$(docker run -d -t -i -p 50070:50070 -p 60010:60010 --dns $NAMESERVER_IP -h master -v  /Users/nanzhu/code/docker/fs/hadoop-2.3.0:/root/hadoop-2.3.0 -v /Users/nanzhu/code/docker/fs/hadoop:/mnt/sda1/hadoop -v /Users/nanzhu/code/docker/fs/hbase-0.98.7:/root/hbase-0.98.7 $1:$2)

    if [ "$MASTER" = "" ]; then
        echo "error: could not start master container from image $1:$2"
        exit 1
    fi

    echo "started master container:      $MASTER"
    sleep 3
    MASTER_IP=$(docker logs $MASTER 2>&1 | grep -oEi "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
    echo "MASTER_IP:                     $MASTER_IP"
    echo "address=\"/master/$MASTER_IP\"" >> $DNSFILE
    # add reverse dns record
    reverse_ip $MASTER_IP
    echo "ptr-record=$REVERSED_IP.in-addr.arpa,master" >> $DNSFILE
}

function start_workers() {
  echo "starting worker containers"
  for i in `seq 1 $WORKER_NUM`; do
        echo "starting worker container"
	      hostname="worker${i}"
        bindhostport=$((50075 + i))
        bindhostport1=$((60030 + i))
        #create work dir
        mkdir -p /Users/nanzhu/code/docker/fs/hadoop/$hostname
        WORKER=$(docker run -d -t -i -p $bindhostport:50075 -p $bindhostport1:60030 --dns $NAMESERVER_IP -h $hostname -v  /Users/nanzhu/code/docker/fs/hadoop-2.3.0:/root/hadoop-2.3.0 -v /Users/nanzhu/code/docker/fs/hadoop/$hostname:/mnt/sda1/hadoop -v /Users/nanzhu/code/docker/fs/hbase-0.98.7:/root/hbase-0.98.7 $1:$2)
        if [ "$WORKER" = "" ]; then
            echo "error: could not start worker container from image $1:$2"
            exit 1
        fi

        echo "started worker container:  $WORKER"
      	sleep 3
      	WORKER_IP=$(docker logs $WORKER 2>&1 | grep -oEi "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
      	echo "address=\"/$hostname/$WORKER_IP\"" >> $DNSFILE
        # add reverse dns record
        reverse_ip $WORKER_IP
        echo "ptr-record=$REVERSED_IP.in-addr.arpa,$hostname" >> $DNSFILE
  done
}

start_nameserver codingcat/dev:nameserver
wait_for_nameserver
start_master codingcat/dev hbase-master
sleep 5
start_workers codingcat/dev hbase-worker
