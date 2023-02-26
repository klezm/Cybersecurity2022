#!/bin/bash

# sudo apt update
# sudo apt install -y \
#     ca-certificates curl gnupg lsb-release \
#     curl wget git gcc rsync build-essential \
#     bat mc

# rustup install nightly

# ##############################
#           Routinator
# ##############################

git clone --depth 1 https://github.com/NLnetLabs/routinator

# # https://blog.apnic.net/2022/04/06/how-to-installing-an-rpki-validator-2/

# cargo install --locked routinator

# # Confirm the five TAL files exist.
# ls -lha ~/.rpki-cache/tals/
# # View the contents of the APNIC TAL file.
# more ~/.rpki-cache/tals/apnic.tal

# # To get an overview of all available TALs use the --list-tals option.
# routinator --tal=list

# # View the current/default configuration of Routinator.
# # routinator config

# # As a test run, use the following command to pull all the validated ROA payloads. Note that this sync process may take some time.
# # routinator -vv vrps # --format csv
# # Note: There may be some messages about validation failed or other types of error messages. These can be ignored.

# ##############################
#             Krill
# ##############################

# https://krill.docs.nlnetlabs.nl/en/stable/install-and-run.html
cargo install --locked krill
git clone --depth 1 https://github.com/NLnetLabs/krill
git clone --depth 1 https://github.com/NLnetLabs/rpki-rs

# ##############################
#           Cargo-Fuzz
# ##############################

# https://github.com/rust-fuzz/cargo-fuzz
# cargo install cargo-fuzz
cargo +nightly install cargo-fuzz
cargo +nightly install afl

# ##############################
#           Cargo-libafl
# ##############################

# https://github.com/AFLplusplus/cargo-libafl
# cargo install -f cargo-libafl
# cargo +nightly install -f cargo-libafl
