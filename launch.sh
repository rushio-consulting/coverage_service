#!/bin/bash

# Start the first process
./server.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start the server: $status"
  exit $status
fi

while ! curl -s localhost:40000/  > /dev/null
do
log_info "Still waiting for server to be up and running"
sleep 1
done

# Start the second process
./main.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start the coverage generation: $status"
  exit $status
fi