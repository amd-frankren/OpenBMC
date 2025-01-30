FILESEXTRAPATHS:prepend:sp7 := "${THISDIR}/${PN}:"

DEPENDS:append:sp7 = " sp7-yaml-config"

EXTRA_OEMESON:append:sp7 = " \
        -Dfru-yaml-gen=${STAGING_DIR_HOST}${datadir}/sp7-yaml-config/ipmi-fru-read.yaml \
        "
