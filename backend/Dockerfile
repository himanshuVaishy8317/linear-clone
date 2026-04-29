# Production Dockerfile for Phoenix 1.8 (Elixir 1.18 + Erlang/OTP 27)
#
# Build:   docker build -t linear_clone .
# Run:     docker run --env-file .env -p 4000:4000 linear_clone
#
# This is a multi-stage build:
#   1. `builder`  : compiles deps + app, runs mix release
#   2. `runner`   : minimal Debian image with only the release artifact

ARG ELIXIR_VERSION=1.18.4
ARG OTP_VERSION=28.5
ARG UBUNTU_VERSION=jammy-20260410

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-ubuntu-${UBUNTU_VERSION}"
ARG RUNNER_IMAGE="ubuntu:jammy"

# ============================================================================
# Stage 1: Builder
# ============================================================================
FROM ${BUILDER_IMAGE} AS builder

# Install build deps
RUN apt-get update -y && \
    apt-get install -y build-essential git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*_*

# Prepare build dir
WORKDIR /app

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set build env to prod
ENV MIX_ENV="prod"

# Install mix dependencies first (cached layer)
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# Copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

# Copy the rest of the application source
COPY priv priv
COPY lib lib

# Compile the release
RUN mix compile

# Changes to runtime config don't require recompiling deps
COPY config/runtime.exs config/

# Copy release-specific files (rel/overlays/bin/server, migrate)
COPY rel rel
RUN mix release

# ============================================================================
# Stage 2: Runner (minimal runtime image)
# ============================================================================
FROM ${RUNNER_IMAGE}

RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses6 locales ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR /app
RUN chown nobody /app

# Set runner env to prod
ENV MIX_ENV="prod"

# Only copy the release output from the builder stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/linear_clone ./

USER nobody

# Default command starts the Phoenix server
# rel/overlays/bin/server sets PHX_SERVER=true and execs `bin/linear_clone start`
CMD ["/app/bin/server"]
