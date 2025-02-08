FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://weston.ini"

do_install:append() {
    install -D -m 0644 ${WORKDIR}/weston.ini ${D}${sysconfdir}/xdg/weston/weston.ini

    install -dm 755 ${D}/home/weston/.config/systemd/user/default.target.wants
    install -dm 755 ${D}/home/weston/.config/systemd/user/sockets.target.wants

    ln -sf /usr/lib/systemd/user/pulseaudio.service ${D}/home/weston/.config/systemd/user/default.target.wants/pulseaudio.service
    ln -sf /usr/lib/systemd/user/pulseaudio.socket ${D}/home/weston/.config/systemd/user/sockets.target.wants/pulseaudio.socket

    chown -R weston:weston ${D}/home/weston/.config
}

FILES:${PN} += "/home/weston/.config/systemd/user/default.target.wants/pulseaudio.service \
                /home/weston/.config/systemd/user/sockets.target.wants/pulseaudio.socket"

