FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

RUN apt-get update && apt-get install -y --no-install-recommends apt-transport-https ca-certificates gnupg curl

# Use IPv4 and reliable mirrors (Koyeb can have issues with default archive.ubuntu.com over IPv6)
RUN sed -i 's|http://.*.ubuntu.com|http://mirror.yandex.ru|g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    aria2 \
    wget \
    curl \
    busybox \
    unzip \
    unrar \
    tar \
    python3 \
    python3-pip \
    ffmpeg \
    p7zip-full \
    p7zip-rar \
    tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# RClone
RUN wget https://rclone.org/install.sh && bash install.sh

# GClone
RUN mkdir /app/gautam && \
    wget -O /app/gautam/gclone.gz https://git.io/JJMSG && \
    gzip -d /app/gautam/gclone.gz && \
    chmod 0775 /app/gautam/gclone

COPY . .
RUN chmod +x extract

CMD ["bash", "start.sh"]
