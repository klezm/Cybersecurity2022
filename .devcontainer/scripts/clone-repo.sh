#!/bin/bash

# https://git-scm.com/book/en/v2/Git-Tools-Submodules
git submodule update --init # --recursive
# git submodule update --remote --merge # pull latest changes from remote for all submodules

# Clone the Repo including submodules https://stackoverflow.com/questions/2144406/how-to-make-shallow-git-submodules
# git clone --depth 1 --recurse-submodules --shallow-submodules <REPO URL>
# Omit --shallow-submodules if you set the option in the .gitmodules file
# git config -f .gitmodules submodule.<name>.shallow true

# Get specific tag of krill repo
git -C krill fetch
git -C krill stash
git -C krill checkout -b v0.12.1 v0.12.1
git -C krill stash pop


GIT_URL=${1:-"none"} # Pass the repo URL as the first argument or use the given default
REPO_NAME=$(basename $GIT_URL .git)
# REPO_NAME=$(echo $GIT_URL | grep -oP '(?<=\/)[^\/]+(?=\.git$)')
# REPO_NAME=${GIT_URL##*/}
REPO_DIR="$REPO_NAME" # REPO_DIR="$CODESPACE_VSCODE_FOLDER/$REPO_NAME"
# REPO_DIR_TMP="$REPO_NAME-TMP"
REPO_DIR_DIFF="$REPO_NAME-diff"

# rm -rf $REPO_DIR

# # [ -d rpki-validator-3/.git ] || (mv rpki-validator-3 rpki-validator-3-TMP && git clone --depth 1 https://github.com/RIPE-NCC/rpki-validator-3 && cp -r rpki-validator-3-TMP/* rpki-validator-3 && rm -rf rpki-validator-3-TMP)
# if [ ! -d $REPO_DIR/.git ]; then
#     echo "  ----- Cloning repo -----"
#     # mv $REPO_NAME $REPO_DIR_TMP
#     git clone --depth 1 $GIT_URL
#     # cp -r $REPO_DIR_TMP/* $REPO_NAME
#     # rm -rf $REPO_DIR_TMP
# else
#     echo "  ----- Repo already cloned -----"
# fi


if [ $REPO_NAME == "rpki-validator-3" ]; then
    VALI_DIR="$REPO_NAME/rpki-validator" # VALI_DIR="$CODESPACE_VSCODE_FOLDER/$REPO_NAME/rpki-validator"

    FUZZ_DIR="$REPO_DIR"
    # FUZZ_DIR=$VALI_DIR
    cifuzz -v -C "$FUZZ_DIR" init
    cifuzz -v -C "$VALI_DIR/src/test/java/net/ripe/rpki/validator3/rrdp/" create java -o FuzzRrdp.java
    # TODO: The following line breaks everything
    # cifuzz -v -C "$VALI_DIR/src/test/java/net/ripe/rpki/validator3/rrdp/" create java -o FuzzTest.java

    cp --verbose "$REPO_DIR_DIFF/pom.xml" "$REPO_DIR/"
    cp --verbose "$REPO_DIR_DIFF/rpki-validator/pom.xml" "$VALI_DIR/"
    cp --verbose "$REPO_DIR_DIFF/rpki-validator/src/test/java/net/ripe/rpki/validator3/rrdp/FuzzRrdp.java" "$VALI_DIR/src/test/java/net/ripe/rpki/validator3/rrdp/"
    # TODO: The following line breaks everything
    # cp --verbose "$REPO_DIR_DIFF/rpki-validator/src/test/java/net/ripe/rpki/validator3/rrdp/FuzzTest.java" "$VALI_DIR/src/test/java/net/ripe/rpki/validator3/rrdp/"

    (cd $REPO_DIR; git status)

    # ls -lha $REPO_DIR | grep -P "(pom|cifuzz)"
    # ls -lha $VALI_DIR | grep -P "(pom|cifuzz)"
    # ls -lha $VALI_DIR/src/test/java/net/ripe/rpki/validator3/rrdp/ | grep Fuzz

    # cifuzz -v -C "$FUZZ_DIR" run FuzzRrdp #--use-sandbox=false
fi
