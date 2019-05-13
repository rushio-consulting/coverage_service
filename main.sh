#!/bin/bash
#
# @description : 
#

CURRENT_PROJECT_NAME='app'

#TODO: Generated UUID 
UUID=$(uuidgen)
ID=${UUID,,} # lower case

EXPECTED_OUTPUT_COVERAGE_DIR="/tmp/rushio-gen-coverage-$ID/coverage"

dart bin/main.dart \
    -p /$CURRENT_PROJECT_NAME \
    -i $ID \
    --report-on lib/src

#TODO: Check if last command success 
# rm -rf $EXPECTED_OUTPUT_COVERAGE_DIR || true # Ignore error in case the directory does not exsit

# rm $CURRENT_PROJECT_NAME/coverage if it exist
rm -rf /$CURRENT_PROJECT_NAME/coverage || true

#TODO: Check if the ouput dir exist
sudo mv $EXPECTED_OUTPUT_COVERAGE_DIR  /$CURRENT_PROJECT_NAME/
