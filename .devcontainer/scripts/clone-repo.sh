#!/bin/bash

GIT_URL="https://github.com/RIPE-NCC/rpki-validator-3"
REPO_DIR=$(basename $GIT_URL .git)
# REPO_DIR=$(echo $GIT_URL | grep -oP '(?<=\/)[^\/]+(?=\.git$)')
# REPO_DIR=${GIT_URL##*/}
REPO_DIR_TMP="$REPO_DIR-TMP"

# [ -d rpki-validator-3/.git ] || (mv rpki-validator-3 rpki-validator-3-TMP && git clone --depth 1 https://github.com/RIPE-NCC/rpki-validator-3 && cp -r rpki-validator-3-TMP/* rpki-validator-3 && rm -rf rpki-validator-3-TMP)
if [ ! -d rpki-validator-3/.git ]; then
    echo "  ----- Cloning repo -----"
    mv $REPO_DIR $REPO_DIR_TMP
    git clone --depth 1 $GIT_URL
    cp -r $REPO_DIR_TMP/* $REPO_DIR
    rm -rf $REPO_DIR_TMP
else
    echo "  ----- Repo already cloned -----"
fi
