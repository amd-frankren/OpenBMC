FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

OBMC_CONSOLE_HOST_TTY:ethanolx = "ttyS0"

SRC_URI:append:ethanolx = "\
        file://server.ttyS0.conf \
"
