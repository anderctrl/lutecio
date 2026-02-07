FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    g++ \
    make \
    git \
    ca-certificates \
    libssl-dev \
    zlib1g-dev \
    libopus-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch v10.1.4 https://github.com/brainboxdotcc/DPP.git /tmp/dpp \
    && cmake -S /tmp/dpp -B /tmp/dpp/build -DCMAKE_BUILD_TYPE=Release \
    && cmake --build /tmp/dpp/build -j$(nproc) \
    && cmake --install /tmp/dpp/build \
    && rm -rf /tmp/dpp

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
