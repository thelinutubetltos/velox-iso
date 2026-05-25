#!/bin/bash
ROOT_PART=$(findmnt -n -o SOURCE /tmp/calamares-root)
ROOT_DISK=$(lsblk -no pkname $ROOT_PART)
ROOT_UUID=$(findmnt -n -o UUID /tmp/calamares-root)

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
