#!/bin/bash

SCRIPT_PATH="${BASH_SOURCE[0]:-$0}";
SCRIPT_DIR=$(dirname $SCRIPT_PATH);
WORKSPACE_DIR=$(realpath $(dirname $SCRIPT_DIR))

# PREP_FUZZ_TARGET_CORPUS=${1:-false}

function reset_corpus() {
    # rm -rf $WORKSPACE_DIR/corpus && mkdir $WORKSPACE_DIR/corpus && cp $WORKSPACE_DIR/Corpus.zip $WORKSPACE_DIR/corpus/ && cd $WORKSPACE_DIR/corpus && unzip Corpus.zip && rm Corpus.zip && cd $OLDPWD
    rm -rf $WORKSPACE_DIR/corpus
    mkdir $WORKSPACE_DIR/corpus
    cp $WORKSPACE_DIR/Corpus.zip $WORKSPACE_DIR/corpus/
    cd $WORKSPACE_DIR/corpus
    unzip Corpus.zip
    rm Corpus.zip
    CORPUS_ELS=($(ls -1))
    mkdir all
    for c in ${CORPUS_ELS[@]}; do
        CORPUS_EL_EXT=${c##*.}
        # echo -e "$c \t $CORPUS_EL_EXT"
        if [ ! -d $CORPUS_EL_EXT ]; then
            mkdir $CORPUS_EL_EXT
        fi
        if [ $CORPUS_EL_EXT == "xml" ]; then
            mkdir -p xml/all
            cp $c xml/all/
            mkdir xml/${c%.*}
            cp $c xml/${c%.*}/
        else
            cp $c $CORPUS_EL_EXT/
        fi
        mv $c all/
    done
    # echo ${CORPUS_ELS[@]} | sort -u
    cd $OLDPWD
}

function make_rsync_corpus() {
    CORPUS_RSYNC_DIR="$WORKSPACE_DIR/corpus/rsync"
    mkdir -p $CORPUS_RSYNC_DIR
    uris=(
        "rsync://host/module/$%&'()*+,-./0123456789:;=ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~"
        "rsync://host/module/"
        "rsync://host/module/foo/"
        "rsync://host/module/foo/bar"
    )

    for ((i=0; i<${#uris[@]}; i++)); do
        printf "%s" $uris[$i] > $CORPUS_RSYNC_DIR/$i
    done
}

function copy_corpus_from_submodule() {
    # cer
    # cp --verbose $WORKSPACE_DIR/rpki-rs/test-data/**/*.cer $WORKSPACE_DIR/corpus/cer/
    find $WORKSPACE_DIR/rpki-rs -name "*.cer" ! -name "*id*" -exec cp --verbose {} $WORKSPACE_DIR/corpus/cer/ \;
    rm $WORKSPACE_DIR/corpus/cer/*incorrect*.cer
    # id cer
    mkdir $WORKSPACE_DIR/corpus/idcer
    find $WORKSPACE_DIR/rpki-rs -name "*id*.cer" -exec cp --verbose {} $WORKSPACE_DIR/corpus/idcer/ \;

    # roa
    # cp --verbose $WORKSPACE_DIR/rpki-validator-3/**/*.roa $WORKSPACE_DIR/corpus/roa/
    find $WORKSPACE_DIR/rpki-validator-3 -name "*.roa" -exec cp --verbose {} $WORKSPACE_DIR/corpus/roa/ \;

    # xml snapshot
    # cp --verbose --backup=numbered $WORKSPACE_DIR/**/*snap*.xml $WORKSPACE_DIR/corpus/xml/snapshot/
    find $WORKSPACE_DIR -name "*snapshot*.xml" -exec cp --verbose {} $WORKSPACE_DIR/corpus/xml/snapshot/ \;

    # xml notification
    find $WORKSPACE_DIR -name "*notification*.xml" -exec cp --verbose {} $WORKSPACE_DIR/corpus/xml/notification/ \;
    rm $WORKSPACE_DIR/corpus/xml/notification/*lolz*.xml
    rm $WORKSPACE_DIR/corpus/xml/notification/*with-gaps*.xml

    # xml delta
    find $WORKSPACE_DIR -name "*delta*.xml" -exec cp --verbose {} $WORKSPACE_DIR/corpus/xml/delta/ \;
}

reset_corpus
make_rsync_corpus
copy_corpus_from_submodule

# PREP_FUZZ_TARGET_CORPUS=true
# if [ $PREP_FUZZ_TARGET_CORPUS == true ]; then
#     fuzz_list=$(cargo +nightly -C $WORKSPACE_DIR/rpki-rs fuzz list)
#     for fuzz_target in $fuzz_list; do
#         echo "Preparing corpus for $fuzz_target"
#     done
# fi
