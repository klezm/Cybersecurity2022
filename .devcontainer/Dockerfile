# https://github.com/devcontainers/images/tree/main/src/rust
# https://hub.docker.com/_/rust
FROM mcr.microsoft.com/devcontainers/rust:0-1-bullseye
# FROM mcr.microsoft.com/devcontainers/base:ubuntu
# FROM phusion/baseimage
# FROM ubuntu:latest
# FROM buildpack-deps:stable

# USER root

# ENV SHELL=/bin/zsh
RUN chsh -s /bin/zsh root
# RUN echo "$USERNAME - $USER - $HOME" && \
#     env | sort && \
#     cat /etc/passwd && \
#     chsh -s /bin/zsh root && \
#     cat /etc/passwd
#     # usermod -s /bin/zsh $USERNAME
#     # chsh -s /bin/zsh vscode

RUN sudo apt update && \
    sudo apt install -y \
        ca-certificates gnupg lsb-release \
        curl wget git gcc rsync build-essential \
        pkg-config libssl-dev openssl \
        bat mc expect colorized-logs
        # gcc-multilib libpq-dev libpq5
        # mesa-opencl-icd ocl-icd-opencl-dev bzr jq clang hwloc libhwloc-dev
        # tini
        # pandoc
        # && apt-get autoremove -y && apt-get clean -y \
        # && apt-get clean -y && rm -rf /tmp/scripts

# RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --profile minimal
# RUN su vscode -c "rustup install nightly && rustup component add rust-src rust-analyzer clippy rustfmt && cargo +nightly install cargo-fuzz" 2>&1

# ARG USERNAME=vscode
RUN rustup install nightly
    # && rustup default nightly
    # && rustup default nightly-2021-09-04
    # 1.56.0 > 2021.10.21       1.56.1 > 2021.11.01
    # && rustup default nightly-1.56
    # && rustup default 1.68.0
# RUN rustup default stable

# Add sources of standard library for rust-analyzer extension in VSCode
# RUN mkdir -p $(rustc --print sysroot)/lib/rustlib/src/rust \ && rustup component add rust-src
RUN rustup component add rust-src rust-analyzer clippy rustfmt
    # && cargo build --package slug
    # cargo install slug
    # && cargo metadata --format-version 1 --manifest-path /workspaces/Cybersecurity2022/krill/Cargo.toml --filter-platform x86_64-unknown-linux-gnu
    # && cargo metadata --format-version 1 --manifest-path /workspaces/Cybersecurity2022/rpki-rs/Cargo.toml --filter-platform x86_64-unknown-linux-gnu

RUN cargo +nightly install cargo-fuzz cargo-test-fuzz afl
    # && cargo install --force cargo-fuzz
# RUN cargo +nightly install -f cargo-libafl
