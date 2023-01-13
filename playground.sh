#!/bin/bash

# reset corpus
rm -rf $CODESPACE_VSCODE_FOLDER/corpus && mkdir $CODESPACE_VSCODE_FOLDER/corpus && cp $CODESPACE_VSCODE_FOLDER/Corpus.zip $CODESPACE_VSCODE_FOLDER/corpus/ && cd $CODESPACE_VSCODE_FOLDER/corpus && unzip Corpus.zip && rm Corpus.zip && cd $OLDPWD

# reset routinator repo
rm -rf $CODESPACE_VSCODE_FOLDER/routinator && git clone --depth 1 https://github.com/NLnetLabs/routinator $CODESPACE_VSCODE_FOLDER/routinator

# init fuzzer
cd routinator
cargo fuzz init # --fuzz-dir routinator --target fuzz_target_1
cargo fuzz list

# run fuzzer
cargo fuzz run --jobs 2 fuzz_target_1 $CODESPACE_VSCODE_FOLDER/corpus
