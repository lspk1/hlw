# Use a Linux base image compatible with Render
FROM ubuntu:latest

# Set metadata
LABEL maintainer="Your Name <your.email@example.com>"

# Install required packages
RUN apt-get update \
    && apt-get install -y \
        curl \
        p7zip \
        wsdd \
        samba \
        wimtools \
        dos2unix \
        cabextract \
        genisoimage \
        libxml2-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download wsdd.py and drivers.iso
ADD https://raw.githubusercontent.com/christgau/wsdd/master/src/wsdd.py /usr/sbin/wsdd
ADD https://github.com/qemus/virtiso/releases/download/v0.1.248/virtio-win-0.1.248.iso /run/drivers.iso

# Copy scripts and asse

# Make scripts executable
RUN chmod +x /run/*.sh && chmod +x /usr/sbin/wsdd

# Set version argument
ARG VERSION_ARG="0.0"
RUN echo "$VERSION_ARG" > /run/version

# Expose ports
EXPOSE 8006 3389

# Set entrypoint
ENTRYPOINT ["/usr/bin/tini", "-s", "/run/entry.sh"]
