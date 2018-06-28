#!bin/bash

## https://wiki.debian.org/BluetoothUser/a2dp




echo "load-module module-switch-on-connect" >> /etc/pulse/default.pa

mv /var/lib/gdm3/.config/systemd/user/sockets.target.wants/pulseaudio.{,nope}socket

chown Debian-gdm:Debian-gdm /var/lib/gdm3/.config/pulse/client.conf

echo -ne "autospawn = no\ndaemon-binary = /bin/true\n" > /var/lib/gdm3/.config/pulse/client.conf

cat << EOFF > /var/lib/gdm3/.config/pulse/default.pa

#!/usr/bin/pulseaudio -nF
#

# load system wide configuration
.include /etc/pulse/default.pa

### unload driver modules for Bluetooth hardware
.ifexists module-bluetooth-policy.so
  unload-module module-bluetooth-policy
.endif

.ifexists module-bluetooth-discover.so
  unload-module module-bluetooth-discover
.endif

EOFF
