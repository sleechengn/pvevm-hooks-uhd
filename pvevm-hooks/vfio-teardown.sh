#!/bin/bash
# set -x

echo "Beginning of teardown!"

# Restart Display Manager
input="/tmp/vfio-store-display-manager"
while read displayManager; do
  if command -v systemctl; then
    systemctl start "$displayManager.service"
    sts=$(systemctl is-active $displayManager.service)
    while [ $sts != "active" ]
    do
	sleep 1
	systemctl start "$displayManager.service"
	sts=$(systemctl is-active $displayManager.service)
    done
  else
    if command -v sv; then
      sv start $displayManager
    fi
  fi
done < "$input"

# Rebind VT consoles (adapted from https://www.kernel.org/doc/Documentation/fb/fbcon.txt)
input="/tmp/vfio-bound-consoles"
while read consoleNumber; do
  if test -x /sys/class/vtconsole/vtcon${consoleNumber}; then
      if [ `cat /sys/class/vtconsole/vtcon${consoleNumber}/name | grep -c "frame buffer"` \
           = 1 ]; then
    echo "Rebinding console ${consoleNumber}"
	  echo 1 > /sys/class/vtconsole/vtcon${consoleNumber}/bind
      fi
  fi
done < "$input"

# Rebind framebuffer for nvidia
if test -e "/tmp/vfio-is-nvidia" ; then
  if [ -f "/sys/bus/platform/drivers/efi-framebuffer/bind" ]; then
    echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind
  fi
fi

echo "End of teardown!"
