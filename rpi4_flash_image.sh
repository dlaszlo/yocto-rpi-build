#!/bin/bash
set -e
set -o pipefail

DEFAULT_IMAGE="build-rpi4/tmp/deploy/images/raspberrypi4-64/rpi-image-raspberrypi4-64.rootfs.wic"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <device> [image]"
    echo "  <device>: Target device (e.g., /dev/sda)"
    echo "  [image]: Optional path to the .wic image (defaults to: $DEFAULT_IMAGE)"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo." >&2
    exit 1
fi

DEVICE=$1
IMAGE=${2:-$DEFAULT_IMAGE}

if [[ ! -b $DEVICE ]]; then
    echo "Error: Device $DEVICE does not exist or is not a block device." >&2
    exit 1
fi

echo "Checking if any partitions on $DEVICE are mounted..."
if mount | grep -q $DEVICE; then
    echo "Unmounting all partitions on $DEVICE..."
    sudo umount ${DEVICE}* || true
    echo "Partitions unmounted successfully."
else
    echo "No mounted partitions found on $DEVICE."
fi

echo "WARNING: This will completely erase $DEVICE and write a new image."
read -p "Are you sure you want to proceed? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    echo "Operation canceled."
    exit 1
fi

echo "Wiping all filesystem signatures from ${DEVICE}..."
wipefs -a $DEVICE

echo "Removing all partitions and GPT/MBR metadata from ${DEVICE}..."
sgdisk --zap-all $DEVICE

echo "Flashing the image $IMAGE.bz2 to $DEVICE using bmaptool..."
bmaptool copy --bmap $IMAGE.bmap $IMAGE.bz2 $DEVICE
sync

echo "Resizing the partition ${DEVICE}2 to use the available free space..."
sudo parted $DEVICE --script resizepart 2 100%

echo "Resizing the filesystem on ${DEVICE}2..."
sudo resize2fs ${DEVICE}2
echo "Filesystem resized successfully."

sync

echo "Flashing completed successfully."
