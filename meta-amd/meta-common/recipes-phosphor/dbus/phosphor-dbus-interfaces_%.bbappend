FILESEXTRAPATHS:prepend := "${THISDIR}/phosphor-dbus-interfaces:"

S = "${WORKDIR}/git"

SRC_URI += "file://0001-phosphor-dbus-interfaces-Add-re-timer-bundle-update-.patch \
            file://0002-Add-enumeration-HPM_FPGA-for-version-property.patch \
            file://0003-meta-amd-dbus-Add-D-Bus-support-for-VR-bundle-update.patch \
            file://0004-Add-AMD-OEM-RAS-configuration-interface.patch \
            file://0005-meta-amd-dbus-Cpu-Add-vendor-ID.patch \
            file://0006-dbus-yaml-added-new-PCIe-yaml-file.patch \
            file://0007-meta-amd-dbus-Add-multi-host-configuration-yaml.patch \
            file://0008-Add-new-properties-hostversions-and-hostnumber.patch \
            file://0009-dbus-yaml-added-support-for-Pending-attributes.patch \
            file://0010-Add-crashdump-interface.patch \
            file://0011-meta-amd-common-dbus-Add-PPR-yaml-for-SP7.patch \
            "
do_configure:prepend() {
  cd ${S}/gen && ./regenerate-meson
}
