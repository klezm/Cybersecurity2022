#!/bin/bash

if false; then
    sudo apt update
    # sudo apt install ca-certificates curl gnupg lsb-release

    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --profile minimal
    source "$HOME/.cargo/env"
fi

rustup self update
# rustup set profile minimal
# rustup toolchain install stable
rustup install nightly
rustup default stable


rustup component add rust-src rust-analyzer clippy rustfmt
# cargo build --package slug
# cargo install slug
# cargo metadata --format-version 1 --manifest-path /workspaces/Cybersecurity2022/krill/Cargo.toml --filter-platform x86_64-unknown-linux-gnu
# cargo metadata --format-version 1 --manifest-path /workspaces/Cybersecurity2022/rpki-rs/Cargo.toml --filter-platform x86_64-unknown-linux-gnu

cargo +nightly install cargo-fuzz # cargo-test-fuzz afl
# cargo install --force cargo-fuzz
# cargo +nightly install -f cargo-libafl

# cargo +nightly install cargo-libafl
# cargo +nightly install cargo-fuzz
# cargo install cargo-fuzz
