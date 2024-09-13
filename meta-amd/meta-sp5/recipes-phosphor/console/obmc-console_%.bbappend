FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

OBMC_CONSOLE_HOST_TTY:sp5 = "ttyS0"

SRC_URI:append:sp5 = "\
        file://server.ttyS0.conf \
"
