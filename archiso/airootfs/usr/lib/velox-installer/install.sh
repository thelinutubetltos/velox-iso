#!/bin/bash
exec > /tmp/velox-install.log 2>&1
set -x

# Find and copy kernel to /boot
KERNEL_VERSION=$(ls /usr/lib/modules/ | sort -V | tail -1)
mkdir -p /boot
cp /usr/lib/modules/$KERNEL_VERSION/vmlinuz /boot/vmlinuz-linux

# Fix mkinitcpio hooks
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)/' /etc/mkinitcpio.conf

# Generate initramfs
mkinitcpio -p linux

# Get disk info
ROOT_PART=$(findmnt -n -o SOURCE /)
ROOT_DISK=$(lsblk -no pkname $ROOT_PART)
ROOT_UUID=$(blkid -s UUID -o value $ROOT_PART)
echo "ROOT_PART=$ROOT_PART ROOT_DISK=$ROOT_DISK ROOT_UUID=$ROOT_UUID"

# Install grub - support both BIOS and UEFI
if [ -d /sys/firmware/efi ]; then
    mkdir -p /boot/efi
    mount /dev/${ROOT_DISK}1 /boot/efi 2>/dev/null || true
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Velox --removable
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Velox
else
    grub-install --target=i386-pc /dev/$ROOT_DISK
fi

# Write grub.cfg
mkdir -p /boot/grub
cat > /boot/grub/grub.cfg << GRUBEOF
set default=0
set timeout=10

menuentry "Velox Linux" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux /boot/vmlinuz-linux root=UUID=$ROOT_UUID rw quiet splash
    initrd /boot/initramfs-linux.img
}

menuentry "Velox Linux - NVIDIA (proprietary)" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux /boot/vmlinuz-linux root=UUID=$ROOT_UUID rw quiet splash nvidia-drm.modeset=1
    initrd /boot/initramfs-linux.img
}

menuentry "Velox Linux - NVIDIA (open source)" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux /boot/vmlinuz-linux root=UUID=$ROOT_UUID rw quiet splash nvidia-drm.modeset=1 nouveau.modeset=1
    initrd /boot/initramfs-linux.img
}

menuentry "Velox Linux - AMD" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux /boot/vmlinuz-linux root=UUID=$ROOT_UUID rw quiet splash amdgpu.modeset=1
    initrd /boot/initramfs-linux.img
}

menuentry "Velox Linux (fallback initramfs)" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux /boot/vmlinuz-linux root=UUID=$ROOT_UUID rw
    initrd /boot/initramfs-linux-fallback.img
}
GRUBEOF

# Fix SDDM autologin user
INSTALL_USER=$(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 && $1 != "liveuser" {print $1; exit}')
sed -i "/\[Autologin\]/a User=$INSTALL_USER" /etc/sddm.conf
