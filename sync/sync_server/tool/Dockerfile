FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
      git curl unzip xz-utils ca-certificates \
      build-essential clang cmake ninja-build pkg-config rsync \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://fvm.app/install.sh | bash
ENV PATH=/root/fvm/bin:$PATH \
    FVM_CACHE_PATH=/fvm-cache

WORKDIR /work