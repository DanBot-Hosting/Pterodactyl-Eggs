# DanBot Hosting — Pterodactyl Eggs and Docker Images
# Copyright (C) 2020-2026 DanBot Hosting <https://danbot.host>
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# This notice must be preserved in modified versions. See LICENSE.

FROM debian:trixie-slim

LABEL maintainer="danielpmc <dan@danbot.host>, DIBSTER <dibster@danbot.host>"
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"
LABEL org.opencontainers.image.vendor="DanBot Hosting"
LABEL org.opencontainers.image.source="https://github.com/DanBot-Hosting/Pterodactyl-Eggs"

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get -y install curl locales git cmake wget unzip \
    && apt-get -y install liblzma-dev lzma \
    && (id -u container >/dev/null 2>&1 || useradd -d /home/container -m container)

# Ensure UTF-8
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

# OpenJDK 21 LTS
RUN apt update \
   && apt install -y libc6-i386 libc6-x32 \
   && wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb -O jdk-21_linux-x64_bin.deb \
   && apt install -y ./jdk-21_linux-x64_bin.deb \
   && rm jdk-21_linux-x64_bin.deb
   
ENV JAVA_HOME=/usr/lib/jvm/jdk-21/
ENV PATH=$PATH:$JAVA_HOME/bin

# NodeJS - Builds latest LTS at the time of building.
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get -y install nodejs imagemagick ffmpeg make build-essential 

# Python 2 & 3
RUN apt update \
   && apt -y install zlib1g-dev libncurses-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev \
   && wget https://www.python.org/ftp/python/3.12.1/Python-3.12.1.tgz \
   && tar -xf Python-3.12.*.tgz \
   && cd Python-3.12.1 \
   && ./configure --enable-optimizations \
   && make -j $(nproc) \
   && make altinstall \
   && cd .. \
   && rm -rf Python-3.12.1 \
   && rm Python-3.12.*.tgz 
   
# Enable global pip installs for container environment (bypasses PEP 668)
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Install Python & Pip
RUN apt-get update && apt-get -y install python3 python3-pip

# Golang
RUN curl -OL https://golang.org/dl/go1.21.5.linux-amd64.tar.gz \
   && tar -C /usr/local -xvf go1.21.5.linux-amd64.tar.gz   
ENV PATH=$PATH:/usr/local/go/bin
ENV GOROOT=/usr/local/go

# Installing NodeJS dependencies for AIO.
RUN npm i -g yarn pm2 pnpm

USER container
ENV USER=container
ENV HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
