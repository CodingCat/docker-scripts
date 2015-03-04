#!/bin/bash

echo "Starting cassandra nodes"

service ssh start

service cassandra start

while [ 1 ];
do
    sleep 3
done
