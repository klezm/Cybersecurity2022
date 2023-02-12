#!/bin/bash

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo -e "\nRun 'sudo su' before executing this script (because of 'cargo fuzz')!\nExiting...\n"
    exit 1
fi

# Reset corpus
# rm -rf $CODESPACE_VSCODE_FOLDER/corpus && mkdir $CODESPACE_VSCODE_FOLDER/corpus && cp $CODESPACE_VSCODE_FOLDER/Corpus.zip $CODESPACE_VSCODE_FOLDER/corpus/ && cd $CODESPACE_VSCODE_FOLDER/corpus && unzip Corpus.zip && rm Corpus.zip && cd $OLDPWD

GIT_URL=${1:-"https://github.com/NLnetLabs/krill"}
# GIT_URL=${1:-"https://github.com/NLnetLabs/rpki-rs"}

# echo "$GIT_URL"; exit 0
REPO_NAME=$(basename $GIT_URL .git)
REPO_DIR="$REPO_NAME" # REPO_DIR="$CODESPACE_VSCODE_FOLDER/$REPO_NAME"

# Reset repo
# rm -rf $CODESPACE_VSCODE_FOLDER/$REPO_NAME && git clone --depth 1 $GIT_URL $CODESPACE_VSCODE_FOLDER/$REPO_NAME
# cp -v -r $REPO_NAME-diff/* $REPO_NAME/; exit 0

# Init fuzzer
cd $REPO_NAME
# cargo fuzz init # --fuzz-dir $REPO_NAME --target fuzz_target_1
cargo fuzz list

# Run fuzzer
# sudo su
# cargo fuzz run --jobs 2 fuzz_target_1 $CODESPACE_VSCODE_FOLDER/corpus
echo "pwd: $(pwd)"
unbuffer cargo fuzz run --jobs 2 fuzz_target_1 ../corpus | tee -a ../stdout.txt

cd $OLDPWD
