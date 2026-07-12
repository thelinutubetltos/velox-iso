#!/bin/bash
exec > /var/log/velox-install.log 2>&1
set -x

# Find and copy kernel to /boot
KERNEL_VERSION=$(ls /usr/lib/modules/ | sort -V | tail -1)
mkdir -p /boot
cp /usr/lib/modules/$KERNEL_VERSION/vmlinuz /boot/vmlinuz-linux-velox

# Fix mkinitcpio hooks
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)/' /etc/mkinitcpio.conf

# Detect root filesystem type early (before initramfs generation)
ROOT_FSTYPE=$(findmnt -n -o FSTYPE /)

# Add btrfs module to initramfs if Btrfs root
if [[ "$ROOT_FSTYPE" == "btrfs" ]]; then
    sed -i 's/^MODULES=.*/MODULES=(btrfs)/' /etc/mkinitcpio.conf
fi

# Generate initramfs
mkinitcpio -p linux-velox

# Get disk info
ROOT_PART=$(findmnt -n -o SOURCE / | sed 's/\[.*\]//')
ROOT_DISK=$(echo $ROOT_PART | sed 's|/dev/||' | sed 's/[0-9]*$//')
ROOT_UUID=$(blkid -s UUID -o value $ROOT_PART)
echo "ROOT_PART=$ROOT_PART ROOT_DISK=$ROOT_DISK ROOT_UUID=$ROOT_UUID ROOT_FSTYPE=$ROOT_FSTYPE"

# Detect NVIDIA GPU and install open kernel modules (Arch dropped nvidia-dkms; only nvidia-open-dkms available)
HAS_NVIDIA=false
GPU_PARAMS=""
if lspci | grep -qi nvidia; then
    echo "NVIDIA GPU detected — installing open kernel modules"
    GPU_PARAMS=" nouveau.modeset=0"

    # Install package — DKMS auto-build may fail for our Clang-built kernel; we patch and rebuild below
    pacman -S --noconfirm --needed nvidia-open-dkms nvidia-utils nvidia-settings 2>&1 || true

    NVIDIA_VER=$(pacman -Q nvidia-open-dkms 2>/dev/null | awk '{print $2}' | cut -d- -f1)
    if [ -n "$NVIDIA_VER" ] && [ -d "/usr/src/nvidia-${NVIDIA_VER}" ]; then
        # velox kernel is Clang-built — add LLVM=1 to the DKMS make command
        sed -i 's/ modules"$/ modules LLVM=1"/' /usr/src/nvidia-${NVIDIA_VER}/dkms.conf

        # Remove any stale built modules so DKMS rebuilds cleanly
        dkms remove "nvidia/${NVIDIA_VER}" -k "$(uname -r)" 2>/dev/null || true

        if dkms install --no-depmod "nvidia/${NVIDIA_VER}" -k "$(uname -r)" 2>&1; then
            depmod "$(uname -r)"
            HAS_NVIDIA=true
            GPU_PARAMS=" nouveau.modeset=0 nvidia-drm.modeset=1"
            sed -i 's/^MODULES=.*/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
            sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf keyboard keymap consolefont block filesystems fsck)/' /etc/mkinitcpio.conf
            mkinitcpio -p linux-velox
            echo "NVIDIA drivers installed — kms hook removed"
        else
            echo "DKMS build failed — GPU may require legacy driver (nvidia-470xx-dkms for pre-Turing GPUs)"
        fi
    else
        echo "nvidia-open-dkms package not available"
    fi
fi

# Install grub
if [ -d /sys/firmware/efi ]; then
    mkdir -p /boot/efi
    mount /dev/${ROOT_DISK}1 /boot/efi 2>/dev/null || true
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Velox --removable
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Velox
else
    grub-install --target=i386-pc /dev/$ROOT_DISK
fi

# Btrfs: GRUB must use explicit subvolume path; kernel needs rootflags
if [[ "$ROOT_FSTYPE" == "btrfs" ]]; then
    BOOT_PREFIX="/@"
    ROOTFLAGS="rootflags=subvol=@ "
else
    BOOT_PREFIX=""
    ROOTFLAGS=""
fi

# Write grub.cfg — NVIDIA entries only added if drivers were installed
mkdir -p /boot/grub
cat > /boot/grub/grub.cfg << GRUBEOF
set default=0
set timeout=10

menuentry "Velox Linux" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux ${BOOT_PREFIX}/boot/vmlinuz-linux-velox root=UUID=$ROOT_UUID ${ROOTFLAGS}rw quiet splash${GPU_PARAMS}
    initrd ${BOOT_PREFIX}/boot/initramfs-linux-velox.img
}
GRUBEOF

if [ "$HAS_NVIDIA" = true ]; then
    cat >> /boot/grub/grub.cfg << GRUBEOF

menuentry "Velox Linux - NVIDIA" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux ${BOOT_PREFIX}/boot/vmlinuz-linux-velox root=UUID=$ROOT_UUID ${ROOTFLAGS}rw quiet splash nouveau.modeset=0 nvidia-drm.modeset=1
    initrd ${BOOT_PREFIX}/boot/initramfs-linux-velox.img
}

menuentry "Velox Linux - NVIDIA (legacy GPU)" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux ${BOOT_PREFIX}/boot/vmlinuz-linux-velox root=UUID=$ROOT_UUID ${ROOTFLAGS}rw quiet splash nouveau.modeset=0 nvidia-drm.modeset=1 nvidia.NVreg_OpenRmEnableUnsupportedGpus=1
    initrd ${BOOT_PREFIX}/boot/initramfs-linux-velox.img
}
GRUBEOF
fi

cat >> /boot/grub/grub.cfg << GRUBEOF

menuentry "Velox Linux - AMD" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux ${BOOT_PREFIX}/boot/vmlinuz-linux-velox root=UUID=$ROOT_UUID ${ROOTFLAGS}rw quiet splash amdgpu.modeset=1
    initrd ${BOOT_PREFIX}/boot/initramfs-linux-velox.img
}

menuentry "Velox Linux (fallback initramfs)" {
    search --no-floppy --fs-uuid --set=root $ROOT_UUID
    linux ${BOOT_PREFIX}/boot/vmlinuz-linux-velox root=UUID=$ROOT_UUID ${ROOTFLAGS}rw
    initrd ${BOOT_PREFIX}/boot/initramfs-linux-velox-fallback.img
}
GRUBEOF

# Btrfs: enable first-boot snapper setup service (runs after full system boot)
if [[ "$ROOT_FSTYPE" == "btrfs" ]]; then
    mkdir -p /etc/systemd/system/multi-user.target.wants
    ln -sf /usr/lib/systemd/system/velox-snapper-setup.service \
           /etc/systemd/system/multi-user.target.wants/velox-snapper-setup.service
fi

# Disable autologin on installed system
sed -i 's/^User=liveuser/User=/' /etc/sddm.conf.d/kde_settings.conf

# Note: autostart files are set up by copy-autostart.sh in shellprocess-post
