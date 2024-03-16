FROM ubuntu:14.04

LABEL maintainer="wingnut0310 <wingnut0310@gmail.com>"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV GOTTY_TAG_VER v1.0.1

# Install required packages including a virtual keyboard
RUN apt-get -y update && \
    apt-get install -y \
        curl \
        xserver-xorg-core \
        xserver-xorg-input-all \
        xserver-xorg-input-libinput \
        xserver-xorg-input-evdev \
        xserver-xorg-input-synaptics \
        xserver-xorg-input-vmmouse \
        xserver-xorg-input-wacom \
        xdotool \
        matchbox-keyboard \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install gotty
RUN curl -sLk https://github.com/yudai/gotty/releases/download/${GOTTY_TAG_VER}/gotty_linux_amd64.tar.gz \
    | tar xzC /usr/local/bin

# Set executable permissions for gotty
RUN chmod +x /usr/local/bin/gotty

# Expose port 8080 for gotty
EXPOSE 8080

# Start gotty with virtual keyboard
CMD ["bash", "-c", "/usr/local/bin/gotty --permit-write --reconnect /bin/bash && matchbox-keyboard"]
