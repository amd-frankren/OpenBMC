SRC_URI:amd = "git://github.com/AMDESE/libpldm;branch=integ_sp7;protocol=https"
SRCREV:amd = "17bc9a5ac4364d799a1ca4a4edd8cc2c0421f93d"

LIBPLDM_OEM ??= "ibm,meta"
PACKAGECONFIG[oem] = "-Doem=${LIBPLDM_OEM},-Doem=[],,"
PACKAGECONFIG[oem-ibm] = ""

EXTRA_OEMESON:append = " -Dtests=false"
