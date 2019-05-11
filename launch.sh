#!/bin/bash

# Start the first process
./server.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start the server: $status"
  exit $status
fi

# Start the second process
./main.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start the coverage generation: $status"
  exit $status
fi