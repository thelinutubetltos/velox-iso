#!/bin/bash
exec > /tmp/velox-install.log 2>&1
set -x

# Copy saved kernel to /boot
mkdir -p /boot
cp /usr/lib/velox-kernel/vmlinuz-linux /boot/vmlinuz-linux

# Fix mkinitcpio hooks
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)/' /etc/mkinitcpio.conf

# Generate initramfs
mkinitcpio -p linux

# Get disk info
ROOT_PART=$(findmnt -n -o SOURCE /)
ROOT_DISK=$(lsblk -no pkname $ROOT_PART)
ROOT_UUID=$(blkid -s UUID -o value $ROOT_PART)

echo "ROOT_PART=$ROOT_PART ROOT_DISK=$ROOT_DISK ROOT_UUID=$ROOT_UUID"

# Install grub to MBR
grub-install --target=i386-pc /dev/$ROOT_DISK

# Write grub.cfg
mkdir -p /boot/grub
cat > /boot/grub/grub.cfg << GRUBEOF
set default=0
set timeout=5

menuentry "Velox Linux" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux /boot/vmlinuz-linux root=UUID=$ROOT_UUID rw quiet splash
    initrd /boot/initramfs-linux.img
}
GRUBEOF

# Fix SDDM autologin user
INSTALL_USER=$(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 && $1 != "liveuser" {print $1; exit}')
sed -i "/\[Autologin\]/a User=$INSTALL_USER" /etc/sddm.conf
