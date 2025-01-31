SUMMARY = "Hungarian locale configuration"
DESCRIPTION = "Hungarian language support package including: \
    UTF-8 character encoding, \
    Hungarian keyboard layout (hu), \
    Console font configuration (Lat2-Therminus16), \
    Locale settings (hu_HU.UTF-8), \
    and all required language and font packages"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit allarch systemd

# Locale generation settings
ENABLE_BINARY_LOCALE_GENERATION = "1"
GLIBC_GENERATE_LOCALES = "hu_HU.UTF-8 en_US.UTF-8"
IMAGE_LINGUAS ?= "hu-hu en-us"

SRC_URI = " \
    file://locale.conf \
    file://vconsole.conf \
    file://locale.sh \
"

do_install() {
    install -d ${D}${sysconfdir}
    install -d ${D}${sysconfdir}/profile.d
    install -m 0644 ${WORKDIR}/locale.conf ${D}${sysconfdir}/
    install -m 0644 ${WORKDIR}/vconsole.conf ${D}${sysconfdir}/
    install -m 0644 ${WORKDIR}/locale.sh ${D}${sysconfdir}/profile.d/
}

FILES:${PN} = " \
    ${sysconfdir}/locale.conf \
    ${sysconfdir}/vconsole.conf \
    ${sysconfdir}/profile.d/locale.sh \
"

RDEPENDS:${PN} += " \
    glibc-utils \
    localedef \
    glibc-binary-localedata-hu-hu \
    glibc-binary-localedata-en-us \
    glibc-gconv-utf-16 \
    glibc-gconv-utf-32 \
    glibc-gconv-ibm850 \
    glibc-charmap-utf-8 \
    glibc-localedata-i18n \
    glibc-localedata-hu-hu \
    glibc-localedata-en-us \
    console-tools \
    kbd \
    kbd-keymaps \
    kbd-consolefonts \
    ttf-dejavu-sans \
    ttf-dejavu-sans-mono \
    ttf-dejavu-sans-condensed \
    ttf-dejavu-serif \
    ttf-dejavu-serif-condensed \
    ttf-dejavu-common \
"

