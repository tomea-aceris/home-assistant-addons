ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

ARG VZDUCH_VERSION

RUN wget -O vzduch.tar.gz https://github.com/tomea-aceris/vzduch-dotek/archive/refs/tags/"${VZDUCH_VERSION}".tar.gz \
    && tar xvzf vzduch.tar.gz -C /usr/src/ \
    && cd /usr/src/vzduch-dotek-"${VZDUCH_VERSION}"

WORKDIR /usr/src/vzduch-dotek-"${VZDUCH_VERSION}"

RUN dotnet restore vzduch-dotek.sln
RUN dotnet publish -c release -o /app -r linux-arm64 --self-contained true --no-restore /p:PublishReadyToRun=true

# final stage/image
FROM mcr.microsoft.com/dotnet/runtime:3.1.12-buster-slim-arm64v8

LABEL Mike <ozczecho@yahoo.com>

COPY --from=build /app .
EXPOSE 5353

COPY data/run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
