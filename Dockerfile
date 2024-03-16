FROM ubuntu:14.04

LABEL maintainer="wingnut0310 <wingnut0310@gmail.com>"

# Install necessary packages for GUI support
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xfonts-base \
    tightvncserver \
    firefox \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up environment variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV GOTTY_TAG_VER v1.0.1
ENV DISPLAY=:1

# Install and configure GoTTY
RUN curl -sLk https://github.com/yudai/gotty/releases/download/${GOTTY_TAG_VER}/gotty_linux_amd64.tar.gz \
    | tar xzC /usr/local/bin

# Copy the script to start GoTTY
COPY run_gotty.sh /run_gotty.sh
RUN chmod 744 /run_gotty.sh

# Expose VNC and GoTTY ports
EXPOSE 5901 8080

# Set up entry point to start VNC server and GoTTY
CMD ["bash", "/run_gotty.sh"]
