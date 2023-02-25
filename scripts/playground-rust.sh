#!/bin/bash

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo -e "\n\nRun 'sudo su' before executing this script (because of 'cargo fuzz')!\nExiting...\n\n"
    exit 1
fi

# GIT_URL=${1:-"https://github.com/NLnetLabs/krill"}
GIT_URL=${1:-"https://github.com/NLnetLabs/rpki-rs"}
# echo "$GIT_URL"; exit 0
REPO_NAME=$(basename $GIT_URL .git)
REPO_DIR="$REPO_NAME" # REPO_DIR="$CODESPACE_VSCODE_FOLDER/$REPO_NAME"
WRITE_LOG=${2:-"false"}
WRITE_LOG="true"
# LOG_PATH="docs/stdout.txt"
LOG_PATH="docs/logs/$(date "+%F-%H_%M_%S").txt"


function reset_corpus() {
    # rm -rf $CODESPACE_VSCODE_FOLDER/corpus && mkdir $CODESPACE_VSCODE_FOLDER/corpus && cp $CODESPACE_VSCODE_FOLDER/Corpus.zip $CODESPACE_VSCODE_FOLDER/corpus/ && cd $CODESPACE_VSCODE_FOLDER/corpus && unzip Corpus.zip && rm Corpus.zip && cd $OLDPWD
    rm -rf $CODESPACE_VSCODE_FOLDER/corpus
    mkdir $CODESPACE_VSCODE_FOLDER/corpus
    cp $CODESPACE_VSCODE_FOLDER/Corpus.zip $CODESPACE_VSCODE_FOLDER/corpus/
    cd $CODESPACE_VSCODE_FOLDER/corpus
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
# reset_corpus

function reset_local_fuzz_results() {
    rm -rf $REPO_DIR/fuzz/corpus
    rm -rf $REPO_DIR/fuzz/artifacts
}
# reset_local_fuzz_results
# rm $REPO_DIR/fuzz/Cargo.lock


# Reset repo
# rm -rf $CODESPACE_VSCODE_FOLDER/$REPO_NAME && git clone --depth 1 $GIT_URL $CODESPACE_VSCODE_FOLDER/$REPO_NAME
# cp -v -r $REPO_NAME-diff/* $REPO_NAME/; exit 0


function rustup_pipeline() {
    rustup default
    rustup self update
    rustup set profile minimal
    rustup toolchain install stable
    # rustup update
    rustup default stable
    # rustup default nightly
    # rustup default nightly-2021-09-04 # 1.56.0
    # rustup default 2021-10-20 # 1.56.0
    # rustup default nightly-2021-11-01 # 1.56.1
    # 1.56.0 > 2021-10-21
    # 1.56.1 > 2021-11-01
}
# rustup_pipeline


# chown -R $USER:$USER $REPO_NAME

# Init fuzzer
cd $REPO_NAME
# cargo -C $REPO_NAME fuzz init # --fuzz-dir $REPO_NAME --target fuzz_target_1
# cargo +nightly -C $REPO_NAME fuzz add fuzz_target_rrdp
# cargo -C $REPO_NAME fuzz list

FUZZING_TARGET=""
# FUZZING_TARGET="fuzz_target_1"
# cargo fuzz list
if [ -z "$FUZZING_TARGET" ]; then
    FUZZING_TARGETS=($(cargo fuzz list))
    for (( i=0; i<${#FUZZING_TARGETS[@]}; i++ )); do
        echo "$i: ${FUZZING_TARGETS[$i]}"
    done
    read -p "Choose a fuzzing target: " -r
    FUZZING_TARGET="${FUZZING_TARGETS[$REPLY]}"
fi
echo "You chose: $FUZZING_TARGET"

# cargo update
# cargo clean

# cargo build --locked #-vv
# cargo build --locked --dev -vv
# cargo build --locked --release -vv
# cargo run --locked --bin krill -vv # --bin krillc --bin krillup
# cargo test -vv

cd $OLDPWD

# Run fuzzer
# sudo su
# cargo -C $REPO_NAME fuzz run --jobs 2 $FUZZING_TARGET $CODESPACE_VSCODE_FOLDER/corpus
echo "pwd: $(pwd)"

if [ $WRITE_LOG == "true" ]; then
    # cat << EOF >> $LOG_PATH
    # echo -e "\n\n##############################################\n\n$(date)\n\n##############################################\n\n" >> $LOG_PATH
    echo -e "\n\n<details><summary>\n<pre>$REPO_NAME\t\t$(date "+%D %T")</pre>\n</summary><pre>\n" >> $LOG_PATH
fi

CORPUS_DIR=""
# CORPUS_DIR="fuzz/corpus"
# CORPUS_DIR="../corpus"
CORPUS_DIR="../corpus/xml/snapshot"
SEED=0 # default: 0
SEED=1880631125 # default: 0
ONLY_ASCII=1 # default: 0
MAX_TOTAL_TIME=$((60*60*6))
echo -e "\nREPO_NAME: $REPO_NAME\nWRITE_LOG: $WRITE_LOG\nLOG_PATH: $LOG_PATH\nFUZZING_TARGET: $FUZZING_TARGET\nCORPUS_DIR: $CORPUS_DIR\nSEED: $SEED\nONLY_ASCII: $ONLY_ASCII\nMAX_TOTAL_TIME: $MAX_TOTAL_TIME\n"
echo -e "\nREPO_NAME: $REPO_NAME\nWRITE_LOG: $WRITE_LOG\nLOG_PATH: $LOG_PATH\nFUZZING_TARGET: $FUZZING_TARGET\nCORPUS_DIR: $CORPUS_DIR\nSEED: $SEED\nONLY_ASCII: $ONLY_ASCII\nMAX_TOTAL_TIME: $MAX_TOTAL_TIME\n\n" >> $LOG_PATH

if [ $WRITE_LOG == "true" ]; then
    # unbuffer cargo +nightly -C $REPO_NAME -vv --locked fuzz run -v $FUZZING_TARGET | tee -a $LOG_PATH
    unbuffer cargo +nightly -C $REPO_NAME -vv --locked fuzz run -v $FUZZING_TARGET $CORPUS_DIR -- -only_ascii=$ONLY_ASCII -seed=$SEED -max_total_time=$MAX_TOTAL_TIME | tee -a $LOG_PATH
    # unbuffer cargo +nightly -C $REPO_NAME -vv fuzz run $FUZZING_TARGET | tee -a $LOG_PATH
    # unbuffer cargo +nightly -C $REPO_NAME fuzz run --jobs 2 $FUZZING_TARGET $CORPUS_DIR | tee -a $LOG_PATH
else
    # exit 0
    # cargo +nightly -C $REPO_NAME -vv build
    # cargo +nightly -C $REPO_NAME -vv fuzz run $FUZZING_TARGET #$CORPUS_DIR
    # cargo +nightly -C $REPO_NAME -vv fuzz run --no-default-features $FUZZING_TARGET #$CORPUS_DIR
    # cargo +nightly -C $REPO_NAME -vv fuzz run -v --dev $FUZZING_TARGET #$CORPUS_DIR
    # cargo +nightly -C $REPO_NAME -vv fuzz run -v --release $FUZZING_TARGET #$CORPUS_DIR
    cargo +nightly -C $REPO_NAME -vv --locked fuzz run -v $FUZZING_TARGET $CORPUS_DIR -- -only_ascii=$ONLY_ASCII -seed=$SEED -max_total_time=$MAX_TOTAL_TIME

    # [--release]/--dev   --jobs [1]/2 --no-default-features/--all-features/--features <...>
    # libFuzzer options (full list: http://llvm.org/docs/LibFuzzer.html#options or `cargo +nightly -C rpki-rs fuzz run fuzz_target_1 -- -help=1`)
    # Some useful options (to be used as `cargo fuzz run fuzz_target -- <options>`)
    # `-- -seed=0`: Random seed. If 0 (the default), the seed is generated.
    # `-- -reload=1`: If set to 1 (the default), the corpus directory is re-read periodically to check for new inputs; this allows detection of new inputs that were discovered by other fuzzing processes.
    # `-- -only_ascii=0`: If 1, generate only ASCII (isprint``+``isspace) inputs. Defaults to 0.
    # `-- -max_len=<len>`: Will limit the length of the input string to `<len>`
    # `-- -runs=<number>`: Will limit the number of tries (runs) before it gives up
    # `-- -max_total_time=<time>`: Will limit the amount of time in sec to fuzz before it gives up
    # `-- -timeout=<time>`: Will limit the amount of time for a single run before it considers that run a failure
fi

if [ $WRITE_LOG == "true" ]; then
    echo -e "\n</pre></details><br>\n\n" >> $LOG_PATH
    ansi2html --unescape <$LOG_PATH >docs/stdout2.html
    # cat docs/stdout2.html | python -c 'import html, sys; [print(html.unescape(l), end="") for l in sys.stdin]' > docs/stdout2.html
    # cat docs/stdout2.html | sed 's/&nbsp;/ /g; s/&amp;/\&/g; s/&lt;/\</g; s/&gt;/\>/g; s/&quot;/\"/g; s/#&#39;/\'"'"'/g; s/&ldquo;/\"/g; s/&rdquo;/\"/g;' > docs/stdout2.html
fi


# cd $OLDPWD
