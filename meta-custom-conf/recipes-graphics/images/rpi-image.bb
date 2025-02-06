SUMMARY = "A very basic Wayland image with a terminal"

IMAGE_FEATURES += "package-management ssh-server-dropbear hwcodecs weston"

LICENSE = "MIT"

inherit core-image

WKS_FILE = "usbimage-raspberrypi.wks"

