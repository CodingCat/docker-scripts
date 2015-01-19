#!/bin/bash

. env.sh

function start_client() {
  echo "starting client container"
  docker run -t -i --dns $3 -h client -v  $LOCAL_FS_HOME/hadoop-2.3.0:/root/hadoop-2.3.0 -v  $LOCAL_FS_HOME/hadoop:/mnt/sda1/hadoop -v $LOCAL_FS_HOME/hbase-0.98.7:/root/hbase-0.98.7 $1:$2 /bin/bash

  sleep 3
}

start_client codingcat/dev basic $1
