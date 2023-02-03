FROM mcr.microsoft.com/devcontainers/rust:0-1-bullseye

RUN sudo apt update && \
    sudo apt install -y \
        ca-certificates curl gnupg lsb-release \
        curl wget git gcc rsync build-essential \
        bat mc

RUN rustup install nightly \
    && rustup default nightly
# RUN rustup default stable

# Add sources of standard library for rust-analyzer extension in VSCode
# RUN mkdir -p $(rustc --print sysroot)/lib/rustlib/src/rust \ && rustup component add rust-src
RUN rustup component add rust-src rust-analyzer clippy rustfmt \
    && cargo build --package slug
    # cargo install slug
    # && cargo metadata --format-version 1 --manifest-path /workspaces/Cybersecurity2022/krill/Cargo.toml --filter-platform x86_64-unknown-linux-gnu
    # && cargo metadata --format-version 1 --manifest-path /workspaces/Cybersecurity2022/rpki-rs/Cargo.toml --filter-platform x86_64-unknown-linux-gnu

RUN cargo +nightly install cargo-fuzz cargo-test-fuzz afl
# RUN cargo +nightly install -f cargo-libafl
