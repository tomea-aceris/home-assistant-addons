ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

ARG VZDUCH_VERSION

RUN mkdir -p /usr/src/ /tmp/vzduch \
  && cd /tmp/vzduch \
  && wget -O vzduch.tar.gz https://github.com/tomea-aceris/vzduch-dotek/archive/refs/tags/${VZDUCH_VERSION}.tar.gz \
  && tar xvzf vzduch.tar.gz -C /usr/src/

WORKDIR /usr/src/vzduch-dotek-${VZDUCH_VERSION}

RUN dotnet restore vzduch-dotek.sln
RUN dotnet publish vzduch-dotek.sln -c release -o /app -r linux-arm64 --self-contained true --no-restore /p:PublishTrimmed=false /p:PublishSingleFile=false

# final stage/image
FROM $BUILD_FROM

LABEL Tome <tome@aceris.com.au>

COPY --from=build /app .
EXPOSE 5353

COPY data/run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
