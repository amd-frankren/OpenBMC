FILESEXTRAPATHS:prepend:sp7 := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
DEPENDS:append:sp7 = " sp7-yaml-config"

EEPROMS_NAME_LIST = "scm hpm"

EEPROMFMT = "system/chassis/{0}"
EEPROM_ESCAPEDFMT = "system-chassis-{0}"
EEPROMS = "${@compose_list(d, 'EEPROMFMT', 'EEPROMS_NAME_LIST')}"
EEPROMS_ESCAPED = "${@compose_list(d, 'EEPROM_ESCAPEDFMT', 'EEPROMS_NAME_LIST')}"

ENVFMT = "obmc/eeproms/{0}"
SYSTEMD_ENVIRONMENT_FILE:${PN}:append:sp7 := " ${@compose_list(d, 'ENVFMT', 'EEPROMS')}"

TMPL = "obmc-read-eeprom@.service"
TGT = "multi-user.target"
INSTFMT = "obmc-read-eeprom@{0}.service"
FMT = "../${TMPL}:${TGT}.wants/${INSTFMT}"

SYSTEMD_LINK:${PN}:append:sp7 := " ${@compose_list(d, 'FMT', 'EEPROMS_ESCAPED')}"

IPMI_FRU_YAML:sp7="${STAGING_DIR_HOST}${datadir}/sp7-yaml-config/ipmi-fru-read.yaml"
IPMI_FRU_PROP_YAML:sp7="${STAGING_DIR_HOST}${datadir}/sp7-yaml-config/ipmi-extra-properties.yaml"
