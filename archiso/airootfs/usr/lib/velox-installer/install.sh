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

# Get disk info from /proc instead of lsblk (works in chroot)
ROOT_PART=$(findmnt -n -o SOURCE / | sed 's/\[.*\]//')
ROOT_UUID=$(blkid -s UUID -o value $ROOT_PART)
ROOT_FS=$(blkid -s TYPE -o value $ROOT_PART)

# Get disk name by stripping partition number from device name
ROOT_DISK=$(echo $ROOT_PART | sed 's|/dev/||' | sed 's/[0-9]*$//')
echo "ROOT_PART=$ROOT_PART ROOT_DISK=$ROOT_DISK ROOT_UUID=$ROOT_UUID ROOT_FS=$ROOT_FS"

# Map filesystem to correct GRUB module name
case $ROOT_FS in
    ext2|ext3|ext4) GRUB_FS="ext2" ;;
    btrfs) GRUB_FS="btrfs" ;;
    xfs) GRUB_FS="xfs" ;;
    f2fs) GRUB_FS="f2fs" ;;
    *) GRUB_FS="ext2" ;;
esac

# Install grub - support both BIOS and UEFI
if [ -d /sys/firmware/efi ]; then
    mkdir -p /boot/efi
    # Find EFI partition from /proc/partitions
    EFI_PART=$(blkid | grep vfat | grep ${ROOT_DISK} | awk -F: '{print $1}' | head -1)
    mount $EFI_PART /boot/efi 2>/dev/null || true
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Velox --removable --modules="part_gpt part_msdos $GRUB_FS"
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Velox --modules="part_gpt part_msdos $GRUB_FS"
else
    grub-install --target=i386-pc /dev/$ROOT_DISK --modules="part_gpt part_msdos $GRUB_FS"
fi

# Write grub.cfg
mkdir -p /boot/grub
cat > /boot/grub/grub.cfg << GRUBEOF
set default=0
set timeout=10
insmod $GRUB_FS

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

# Disable autologin on installed system
sed -i 's/^User=liveuser/User=/' /etc/sddm.conf.d/kde_settings.conf
