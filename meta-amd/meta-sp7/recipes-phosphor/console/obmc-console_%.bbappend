FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

OBMC_CONSOLE_HOST_TTY:sp7 = "ttyS9"

SRC_URI:append:sp7 = "\
        file://server.ttyS9.conf \
        file://80-sp7-obmc-console-uart.rules \
"

do_install:append:sp7() {
        # Replace OpenBMC obmc-console default udev rules with sp7 specific
        install -d ${D}/${nonarch_base_libdir}/udev/rules.d
        rm -rf ${D}${nonarch_base_libdir}/udev/rules.d/80-obmc-console-uart.rules
        install -m 0644 ${WORKDIR}/80-sp7-obmc-console-uart.rules ${D}/${nonarch_base_libdir}/udev/rules.d
}
