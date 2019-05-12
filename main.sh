#!/bin/bash
#
# @description : 
#

#TODO: Generated UUID 
UUID=$(uuidgen)
ID=${UUID,,} # lower case

EXPECTED_OUTPUT_COVERAGE_DIR="/tmp/rushio-gen-coverage-$ID/coverage"

dart bin/main.dart \
    -p /coverage-project \
    -i $ID

#TODO: Check if last command success 

#TODO: Check if the ouput dir exist
mv $EXPECTED_OUTPUT_COVERAGE_DIR  /coverage-project/