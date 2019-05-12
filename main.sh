#!/bin/bash
#
# @description : 
#

ID=123456789
EXPECTED_OUTPUT_COVERAGE_DIR="/tmp/rushio-gen-coverage-$ID/coverage"

dart bin/main.dart \
    -p /coverage-project \
    -i 123456789

#TODO: Check if last command success 

#TODO: Check if the ouput dir exist
mv $EXPECTED_OUTPUT_COVERAGE_DIR  /coverage-project/
