#!/bin/bash

function start_client() {
  echo "starting client container"
  docker run -t -i --dns $3 -h client -v /Users/nanzhu/code/spark:/root/spark -v  /Users/nanzhu/code/docker/fs/hadoop-2.3.0:/root/hadoop-2.3.0 -v /Users/nanzhu/code/docker/fs/hadoop:/mnt/sda1/hadoop -v /Users/nanzhu/code/docker/fs/hbase-0.98.7:/root/hbase-0.98.7 $1:$2 /bin/bash

  sleep 3
}

start_client codingcat/dev basic $1
