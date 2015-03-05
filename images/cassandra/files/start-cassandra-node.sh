#!/bin/bash

echo "Starting cassandra service"

service cassandra start

while [ 1 ];
do
    sleep 3
done
