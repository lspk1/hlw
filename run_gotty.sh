#!/bin/bash

# Start Xvfb
Xvfb :0 -screen 0 1024x768x24 &

# Start XFCE4 desktop environment
startxfce4 &

# Set up password for VNC server
echo "123456" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Start VNC server
x11vnc -display :0 -rfbauth ~/.vnc/passwd -forever &

# Start GoTTY
/usr/local/bin/gotty --permit-write --reconnect /bin/bash
