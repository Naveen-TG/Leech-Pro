FROM ubuntu:20.04

# Set non-interactive mode and timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Create and set working directory
RUN mkdir -p /app && chmod 777 /app
WORKDIR /app

# Update and install dependencies
RUN apt-get update -qq && \
    apt-get install -y -qq --no-install-recommends \
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

# Install Python requirements
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy project files and make extract script executable
COPY . .
RUN chmod +x extract

# Start script
CMD ["bash", "start.sh"]
