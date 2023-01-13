FROM mcr.microsoft.com/devcontainers/rust:0-1-bullseye

RUN sudo apt update && \
    sudo apt install -y \
        ca-certificates curl gnupg lsb-release \
        curl wget git gcc rsync build-essential \
        bat mc

RUN rustup install nightly \
    && rustup default nightly
# RUN rustup default stable

RUN cargo +nightly install cargo-fuzz afl
# RUN cargo +nightly install -f cargo-libafl
