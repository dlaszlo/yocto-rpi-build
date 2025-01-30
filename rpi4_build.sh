#!/bin/bash
source poky/oe-init-build-env build-rpi4
bitbake core-image-weston
