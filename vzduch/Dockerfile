ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

ARG VZDUCH_VERSION
WORKDIR /tmp

# Download and extract
RUN apt-get update && apt-get install -y wget \
  && wget -O vzduch.tar.gz https://github.com/tomea-aceris/vzduch-dotek/archive/refs/tags/${VZDUCH_VERSION}.tar.gz \
  && mkdir -p /tmp/build \
  && tar xzf vzduch.tar.gz -C /tmp/build --strip-components=1 \
  && rm vzduch.tar.gz

# Set working dir to extracted content
WORKDIR /tmp/build

RUN dotnet restore vzduch-dotek.sln
RUN dotnet publish vzduch-dotek.sln -c release -o /app -r linux-arm64 --self-contained true --no-restore /p:PublishReadyToRun=true

# final stage/image
FROM $BUILD_FROM

LABEL Tome <tome@aceris.com.au>

COPY --from=build /app .
EXPOSE 5353

COPY data/run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
