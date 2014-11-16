#!/bin/bash

function start_client() {
  echo "starting client container"
  CLIENT=$(docker run -t -i --dns $3 -h client -v  /Users/nanzhu/code/docker/fs/hadoop-2.3.0:/root/hadoop-2.3.0 -v /Users/nanzhu/code/docker/fs/hadoop:/mnt/sda1/hadoop -v /Users/nanzhu/code/docker/fs/hbase-0.98.7:/root/hbase-0.98.7 $1:$2 /bin/bash)

  if [ "$CLIENT" = "" ]; then
      echo "error: could not start client container from image $1:$2"
      exit 1
  fi

  echo "started client container with master IP address $CLIENT"
  sleep 3
}

start_client codingcat/dev basic $1
