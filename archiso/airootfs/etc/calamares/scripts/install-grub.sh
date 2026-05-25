#!/bin/bash
exec > /tmp/velox-grub-install.log 2>&1
set -x

ROOT_PART=$(findmnt -n -o SOURCE /tmp/calamares-root)
ROOT_DISK=$(lsblk -no pkname $ROOT_PART)
ROOT_UUID=$(blkid -s UUID -o value $ROOT_PART)

echo "ROOT_PART=$ROOT_PART"
echo "ROOT_DISK=$ROOT_DISK"
echo "ROOT_UUID=$ROOT_UUID"

grub-install --target=i386-pc --boot-directory=/tmp/calamares-root/boot /dev/$ROOT_DISK

mkdir -p /tmp/calamares-root/boot/grub
cat > /tmp/calamares-root/boot/grub/grub.cfg << GRUBEOF
set default=0
set timeout=5

menuentry "Velox Linux" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux /boot/vmlinuz-linux root=UUID=$ROOT_UUID rw quiet splash
    initrd /boot/initramfs-linux.img
}
GRUBEOF

mount --bind /proc /tmp/calamares-root/proc
mount --bind /sys /tmp/calamares-root/sys
mount --bind /dev /tmp/calamares-root/dev
mount --bind /run /tmp/calamares-root/run
chroot /tmp/calamares-root mkinitcpio -p linux
umount /tmp/calamares-root/proc /tmp/calamares-root/sys /tmp/calamares-root/dev /tmp/calamares-root/run 2>/dev/null || true
