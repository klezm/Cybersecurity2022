#!/bin/bash

SCRIPT_PATH="${BASH_SOURCE[0]:-$0}";
SCRIPT_DIR=$(dirname $SCRIPT_PATH);
# OLD_DIR=$(pwd)

function extract_crashes() {
    cd $SCRIPT_DIR/../docs/gh-actions
    ZIP_NAME=${1:-"runs4274253560jobs7440736372-fuzzing-corpus-artifacts-coverage.zip"}
    for ZIP_NAME in $(ls *.zip); do
        ID_NAME="$(echo $ZIP_NAME | cut -d'-' -f1)"
        echo -e "\nID_NAME: $ID_NAME\t\tZIP_NAME: $ZIP_NAME"
        # rm -rf $ID_NAME
        unzip -n -d $ID_NAME $ZIP_NAME "artifacts/**/*"
        # 7z x -o$(basename $ZIP_NAME .zip) $ZIP_NAME "artifacts"
    done
}

extract_crashes

# cd $OLD_DIR
