FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    g++ \
    make \
    wget \
    ca-certificates \
    libssl-dev \
    zlib1g-dev \
    libopus-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/brainboxdotcc/DPP/releases/download/v10.1.4/libdpp-10.1.4-linux-rpi-arm64.deb -O dpp.deb \
    && dpkg -i dpp.deb \
    && rm dpp.deb

WORKDIR /app
COPY . .

RUN mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc)

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 \
    libopus0 \
    zlib1g \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/build/lutecio .

RUN useradd -m botuser
USER botuser

CMD ["./lutecio"]
