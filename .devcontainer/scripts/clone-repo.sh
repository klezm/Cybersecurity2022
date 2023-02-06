#!/bin/bash

GIT_URL="https://github.com/RIPE-NCC/rpki-validator-3"
REPO_NAME=$(basename $GIT_URL .git)
# REPO_NAME=$(echo $GIT_URL | grep -oP '(?<=\/)[^\/]+(?=\.git$)')
# REPO_NAME=${GIT_URL##*/}
# REPO_DIR_TMP="$REPO_NAME-TMP"
REPO_DIR_DIFF="$REPO_NAME-diff"

# rm -rf $REPO_NAME

# [ -d rpki-validator-3/.git ] || (mv rpki-validator-3 rpki-validator-3-TMP && git clone --depth 1 https://github.com/RIPE-NCC/rpki-validator-3 && cp -r rpki-validator-3-TMP/* rpki-validator-3 && rm -rf rpki-validator-3-TMP)
if [ ! -d rpki-validator-3/.git ]; then
    echo "  ----- Cloning repo -----"
    # mv $REPO_NAME $REPO_DIR_TMP
    git clone --depth 1 $GIT_URL
    # cp -r $REPO_DIR_TMP/* $REPO_NAME
    # rm -rf $REPO_DIR_TMP
else
    echo "  ----- Repo already cloned -----"
fi

REPO_DIR="$CODESPACE_VSCODE_FOLDER/$REPO_NAME"
VALI_DIR="$CODESPACE_VSCODE_FOLDER/$REPO_NAME/rpki-validator"

FUZZ_DIR="$REPO_DIR"
# FUZZ_DIR=$VALI_DIR

cifuzz -v -C "$FUZZ_DIR" init
cifuzz -v -C "$VALI_DIR/src/test/java/net/ripe/rpki/validator3/rrdp/" create java -o FuzzRrdp.java
# TODO: The following line breaks everything
# cifuzz -v -C "$VALI_DIR/src/test/java/net/ripe/rpki/validator3/rrdp/" create java -o FuzzTest.java

cp --verbose rfuz/pom.xml "$REPO_DIR/"
cp --verbose rfuz/rpki-validator/pom.xml "$VALI_DIR/"
cp --verbose rfuz/rpki-validator/src/test/java/net/ripe/rpki/validator3/rrdp/FuzzRrdp.java "$VALI_DIR/src/test/java/net/ripe/rpki/validator3/rrdp/"
# TODO: The following line breaks everything
# cp --verbose rfuz/rpki-validator/src/test/java/net/ripe/rpki/validator3/rrdp/FuzzTest.java "$VALI_DIR/src/test/java/net/ripe/rpki/validator3/rrdp/"

(cd $REPO_DIR; git status)

# ls -lha $REPO_DIR | grep -P "(pom|cifuzz)"
# ls -lha $VALI_DIR | grep -P "(pom|cifuzz)"
# ls -lha $VALI_DIR/src/test/java/net/ripe/rpki/validator3/rrdp/ | grep Fuzz

# cifuzz -v -C "$FUZZ_DIR" run FuzzRrdp #--use-sandbox=false
