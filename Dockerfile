FROM debian:trixie-slim AS builder

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

RUN set -eux; \
    ARCH=$(dpkg --print-architecture); \
    if [ "$ARCH" = "arm64" ]; then \
    DPP_DEB="libdpp-10.1.4-linux-rpi-arm64.deb"; \
    elif [ "$ARCH" = "amd64" ]; then \
    DPP_DEB="libdpp-10.1.4-linux-x64.deb"; \
    else \
    echo "Unsupported architecture: $ARCH"; exit 1; \
    fi; \
    wget "https://github.com/brainboxdotcc/DPP/releases/download/v10.1.4/${DPP_DEB}" -O /tmp/${DPP_DEB}; \
    dpkg -i /tmp/${DPP_DEB}; \
    rm -f /tmp/${DPP_DEB}; \
    ldconfig

WORKDIR /app
COPY . .
RUN mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc)

FROM debian:trixie-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 \
    libopus0 \
    zlib1g \
    ca-certificates \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    ARCH=$(dpkg --print-architecture); \
    if [ "$ARCH" = "arm64" ]; then \
    DPP_DEB="libdpp-10.1.4-linux-rpi-arm64.deb"; \
    elif [ "$ARCH" = "amd64" ]; then \
    DPP_DEB="libdpp-10.1.4-linux-x64.deb"; \
    else \
    echo "Unsupported architecture: $ARCH"; exit 1; \
    fi; \
    wget "https://github.com/brainboxdotcc/DPP/releases/download/v10.1.4/${DPP_DEB}" -O /tmp/${DPP_DEB}; \
    dpkg -i /tmp/${DPP_DEB}; \
    rm -f /tmp/${DPP_DEB}; \
    ldconfig

WORKDIR /app
COPY --from=builder /app/build/lutecio .

RUN useradd -m botuser
USER botuser

CMD ["./lutecio"]
