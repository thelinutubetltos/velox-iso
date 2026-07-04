#!/bin/bash
INSTALL_USER=$(ls /home | grep -v lost+found | head -1)
if [ -n "$INSTALL_USER" ]; then
    mkdir -p /home/$INSTALL_USER/.config/autostart
    cat > /home/$INSTALL_USER/.config/autostart/velox-announce.desktop << DESKTOPEOF
[Desktop Entry]
Type=Application
Name=Velox Control Center Announcement
Exec=velox-announce
Terminal=false
Hidden=false
X-KDE-autostart-phase=2
DESKTOPEOF
    cat > /home/$INSTALL_USER/.config/autostart/set-resolution.desktop << DESKTOPEOF
[Desktop Entry]
Type=Application
Name=Set Resolution
Exec=/usr/bin/velox-set-resolution
Hidden=false
NoDisplay=true
X-KDE-StartupNotify=false
DESKTOPEOF
    chown -R ${INSTALL_USER}:${INSTALL_USER} /home/${INSTALL_USER}/.config/
fi

# Btrfs: ensure mountpoints exist and rewrite fstab with clean subvolume entries
# (Calamares may include subvolid= or other stale options that break boot)
ROOT_FSTYPE=$(findmnt -n -o FSTYPE / 2>/dev/null || true)
if [[ "$ROOT_FSTYPE" == "btrfs" ]]; then
    mkdir -p /var/log
    BTRFS_PART=$(findmnt -n -o SOURCE / | sed 's/\[.*\]//')
    BTRFS_UUID=$(blkid -s UUID -o value "$BTRFS_PART")
    sed -i '/[[:space:]]btrfs[[:space:]]/d' /etc/fstab
    printf "UUID=%s  /        btrfs  noatime,compress=zstd,subvol=@      0 0\n" "$BTRFS_UUID" >> /etc/fstab
    printf "UUID=%s  /home    btrfs  noatime,compress=zstd,subvol=@home  0 0\n" "$BTRFS_UUID" >> /etc/fstab
    printf "UUID=%s  /var/log btrfs  noatime,compress=zstd,subvol=@log   0 0\n" "$BTRFS_UUID" >> /etc/fstab
fi

# Remove liveuser from installed system
userdel -r liveuser 2>/dev/null || true

# Remove installer entries from applications menu and autostart
rm -f /usr/share/applications/install-velox.desktop
rm -f /usr/share/applications/calamares.desktop
rm -f /root/Desktop/install-velox.desktop
rm -f /root/.config/autostart/calamares.desktop
