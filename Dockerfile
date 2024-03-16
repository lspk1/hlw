# Use an appropriate Windows base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set metadata
LABEL maintainer="Your Name <your.email@example.com>"

# Set environment variables
ENV DEBCONF_NOWARNINGS="yes" \
    DEBIAN_FRONTEND="noninteractive" \
    DEBCONF_NONINTERACTIVE_SEEN="true" \
    RAM_SIZE="4G" \
    CPU_CORES="2" \
    DISK_SIZE="64G" \
    VERSION="win11"

# Expose ports
EXPOSE 8006 3389

# Install required packages
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco install -y curl 7zip dos2unix cabextract genisoimage

# Download wsdd.py and drivers.iso
ADD https://raw.githubusercontent.com/christgau/wsdd/master/src/wsdd.py /usr/sbin/wsdd
ADD https://github.com/qemus/virtiso/releases/download/v0.1.248/virtio-win-0.1.248.iso /run/drivers.iso

# Copy scripts and assets
COPY ./src /run/
COPY ./assets /run/assets

# Make scripts executable
RUN chmod +x /run/*.sh && chmod +x /usr/sbin/wsdd

# Set version argument
ARG VERSION_ARG="0.0"
RUN echo "$VERSION_ARG" > /run/version

# Set entrypoint
ENTRYPOINT ["C:/tini/tini.exe", "-s", "/run/entry.sh"]
