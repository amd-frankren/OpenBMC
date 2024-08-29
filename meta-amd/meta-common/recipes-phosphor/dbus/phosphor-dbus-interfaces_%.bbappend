FILESEXTRAPATHS:prepend := "${THISDIR}/phosphor-dbus-interfaces:"

S = "${WORKDIR}/git"

SRC_URI += "file://0001-phosphor-dbus-interfaces-Add-re-timer-bundle-update-.patch \
            file://0002-Add-enumeration-HPM_FPGA-for-version-property.patch \
            file://0003-meta-amd-dbus-Add-D-Bus-support-for-VR-bundle-update.patch \
	   "

do_configure:append() {
  cd ${S}/gen && ./regenerate-meson
}
