#!/bin/bash
CHROOT=$(ls -d /tmp/calamares-root-* 2>/dev/null | head -1)
mkdir -p $CHROOT/dev $CHROOT/proc $CHROOT/sys
mount --bind /dev $CHROOT/dev
mount --bind /proc $CHROOT/proc
mount --bind /sys $CHROOT/sys
chroot $CHROOT /usr/lib/velox-installer/install.sh
