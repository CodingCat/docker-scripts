#!/bin/bash

. bin/env.sh

source $SCRIPT_HOME/bin/start-nameserver.sh
source $SCRIPT_HOME/bin/start-hadoop.sh

WORKER_NUM=$1

start_nameserver codingcat/dev:nameserver
wait_for_nameserver
start_master codingcat/dev hbase-master
sleep 5
start_workers codingcat/dev hbase-worker $WORKER_NUM
