#!/bin/bash
#Start HDFS service in multiple containers

. bin/env.sh

MASTER=-1
MASTER_IP=

source $SCRIPT_HOME/bin/start-nameserver.sh

# starts the HDFS master container
function start_master() {
    echo "starting master container"
    MASTER=$(docker run -d -t -i -p 50070:50070 -p 60010:60010 --dns $NAMESERVER_IP -h master -v  $LOCAL_FS_HOME/hadoop-2.3.0:/root/hadoop-2.3.0 -v $LOCAL_FS_HOME/hadoop:/mnt/sda1/hadoop -v $LOCAL_FS_HOME/hbase-0.98.7:/root/hbase-0.98.7 $1:$2)

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
  for i in `seq 1 $3`; do
        echo "starting worker container"
	      hostname="worker${i}"
        bindhostport=$((50075 + i))
        bindhostport1=$((60030 + i))
        #create work dir
        mkdir -p /Users/nanzhu/code/docker/fs/hadoop/$hostname
        WORKER=$(docker run -d -t -i -p $bindhostport:50075 -p $bindhostport1:60030 --dns $NAMESERVER_IP -h $hostname -v  $LOCAL_FS_HOME/hadoop-2.3.0:/root/hadoop-2.3.0 -v  $LOCAL_FS_HOME/hadoop/$hostname:/mnt/sda1/hadoop -v $LOCAL_FS_HOME/hbase-0.98.7:/root/hbase-0.98.7 $1:$2)
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
