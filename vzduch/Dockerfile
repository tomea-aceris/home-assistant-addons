# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

ARG VZDUCH_VERSION
ENV LANG C.UTF-8

RUN mkdir -p /usr/src/ /tmp/vzduch \
  && cd /tmp/vzduch \
  && wget -O vzduch.tar.gz https://github.com/tomea-aceris/vzduch-dotek/archive/refs/tags/${VZDUCH_VERSION}.tar.gz \
  && tar xvzf vzduch.tar.gz -C /usr/src/

WORKDIR /usr/src/vzduch-dotek-${VZDUCH_VERSION}

RUN dotnet restore vzduch-dotek.sln
RUN dotnet publish vzduch-dotek.sln -c Release -o /app -r linux-arm64 --self-contained false /p:PublishTrimmed=false /p:PublishSingleFile=false

# Final stage (runtime)
FROM mcr.microsoft.com/dotnet/aspnet:8.0

LABEL maintainer="Tome <tome@aceris.com.au>"

# Install jq to support config parsing in run.sh
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

COPY --from=build /app /app
WORKDIR /app

EXPOSE 5353

COPY data/run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
