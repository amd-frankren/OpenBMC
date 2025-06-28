SRC_URI:amd = "git://github.com/AMDESE/libpldm;branch=integ_sp7;protocol=https"
SRCREV:amd = "df4df207523175b4c2c88033de48afb199adda60"

LIBPLDM_OEM ??= "ibm,meta"
PACKAGECONFIG[oem] = "-Doem=${LIBPLDM_OEM},-Doem=[],,"
PACKAGECONFIG[oem-ibm] = ""

EXTRA_OEMESON:append = " -Dtests=false"
