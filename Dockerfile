FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Create working directory
RUN mkdir -p /app && chmod 777 /app
WORKDIR /app

# Fix apt IPv6/network issues and install packages
RUN apt-get -o Acquire::ForceIPv4=true update -qq && \
    apt-get -o Acquire::ForceIPv4=true install -y -qq --no-install-recommends \
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
        tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install rclone
RUN wget -q https://rclone.org/install.sh && \
    bash install.sh && \
    rm install.sh

# Setup gclone
RUN mkdir -p /app/gautam && \
    wget -q -O /app/gautam/gclone.gz https://git.io/JJMSG && \
    gunzip /app/gautam/gclone.gz && \
    chmod +x /app/gautam/gclone

# Install Python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy rest of the app
COPY . .

# Make start script executable
RUN chmod +x start.sh

# Start the bot
CMD ["bash", "start.sh"]
