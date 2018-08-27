#!/bin/bash

# This script extracts testcases and performs testcase minimization. 
# It requires an execeutable binary to exist

# solc/solfuzzer binary
SOLC=/datadrive/solidity/build/test/tools/solfuzzer
# Location to place testcases
TESTCASES=/datadrive/solidity_input

# Extract testcases 
TMP=/datadrive/tmp
mkdir $TMP
mkdir $TESTCASES
set -e

cd $TMP
for f in /datadrive/solidity/test/libsolidity/*.cpp; do
 python /datadrive/solidity/scripts/extract_test_cases.py $f
done


# Minimize and remove irrelevant files
afl-cmin -i $TMP -o /$TESTCASES -m 100 $SOLC

# Minimize individual files
cd $TMP
for f in *.sol; do
 afl-tmin -i $f -o $TESTCASES/$f -m 100 $SOLC
done

rm -rf $TMP

