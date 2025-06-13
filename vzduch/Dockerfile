# --------------------------------------------
# Stage 1: Build the vzduch-dotek .NET app
# --------------------------------------------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

ARG VZDUCH_VERSION

ARG CACHE_BREAKER=force_rebuild_202506131113
LABEL cache_breaker=${CACHE_BREAKER}

WORKDIR /tmp

# Install dependencies and download the release tarball
RUN apt-get update && apt-get install -y wget \
  && wget -O vzduch.tar.gz https://github.com/tomea-aceris/vzduch-dotek/archive/refs/tags/1.0.0.tar.gz \
  && mkdir -p /tmp/build \
  && tar xzf vzduch.tar.gz -C /tmp/build --strip-components=1 \
  && rm vzduch.tar.gz

# Set working directory to extracted source
WORKDIR /tmp/build

# Restore and publish for linux-arm64 (Rock Pi 4c+)
RUN dotnet restore vzduch-dotek.sln \
  && dotnet publish vzduch-dotek.sln -c Release -o /app \
     -r linux-arm64 --self-contained true --no-restore \
     /p:PublishReadyToRun=true

# --------------------------------------------
# Stage 2: Final runtime container for Home Assistant
# --------------------------------------------
ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8
LABEL maintainer="Tome <tome@aceris.com.au>"

# Copy the published app from build stage
COPY --from=build /app /app

# Copy run script and set permissions
COPY data/run.sh /
RUN chmod +x /run.sh

WORKDIR /app
EXPOSE 5353

# Start the app
CMD ["/run.sh"]
