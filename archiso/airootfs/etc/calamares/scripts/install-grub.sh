#!/bin/bash
ROOT_PART=$(findmnt -n -o SOURCE /tmp/calamares-root)
ROOT_DISK=$(lsblk -no pkname $ROOT_PART)
ROOT_UUID=$(findmnt -n -o UUID /tmp/calamares-root)

# Install GRUB to MBR
grub-install --target=i386-pc --boot-directory=/tmp/calamares-root/boot /dev/$ROOT_DISK

# Generate grub.cfg
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

# Generate proper initramfs
mount --bind /proc /tmp/calamares-root/proc
mount --bind /sys /tmp/calamares-root/sys
mount --bind /dev /tmp/calamares-root/dev
mount --bind /run /tmp/calamares-root/run
chroot /tmp/calamares-root mkinitcpio -p linux
umount /tmp/calamares-root/proc /tmp/calamares-root/sys /tmp/calamares-root/dev /tmp/calamares-root/run 2>/dev/null || true
