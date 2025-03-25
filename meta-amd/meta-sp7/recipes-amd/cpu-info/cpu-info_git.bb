SUMMARY = "AMD CPU Info module"
DESCRIPTION = "CPU Info module creates the processor inventory D-BUS object \
path and updates the Cpu interface properties by reading the CPU values of \
the SOC from the esmi OOB library API's"
LICENSE = "CLOSED"
FILESEXTRAPATHS:prepend := "${THISDIR}:"
inherit meson pkgconfig systemd
SRC_URI = "git://git@github.com/AMDESE/bmc-cpuinfo.git;branch=integ_sp7;protocol=ssh"
SRCREV = "e6ab43699834409b5e1fbed53edcb61133ffb226"
S = "${WORKDIR}/git"
DEPENDS += " \
    amd-apml \
    i2c-tools \
    libgpiod \
    phosphor-dbus-interfaces \
    phosphor-logging \
    sdbusplus \
    "
do_configure:prepend() {
    install -d ${STAGING_DIR_HOST}${includedir}/linux
    install -m 0755 ${STAGING_KERNEL_DIR}/include/uapi/linux/amd-apml.h ${STAGING_DIR_HOST}${includedir}/linux/amd-apml.h
}

SYSTEMD_SERVICE:${PN} = "xyz.openbmc_project.Inventory.Item.Cpu_info.service"
