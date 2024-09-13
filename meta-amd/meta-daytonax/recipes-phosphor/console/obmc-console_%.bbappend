FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

OBMC_CONSOLE_HOST_TTY:daytonax = "ttyS0"

SRC_URI:append:daytonax = "\
        file://server.ttyS0.conf \
"
