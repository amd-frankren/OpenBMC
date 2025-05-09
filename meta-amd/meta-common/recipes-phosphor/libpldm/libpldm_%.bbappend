SRC_URI:amd = "git://github.com/AMDESE/libpldm;branch=integ_sp7;protocol=https"
SRCREV:amd = "238dab8162430a35948bad41b4ee484ab9c4ac32"

LIBPLDM_OEM ??= "ibm,meta"
PACKAGECONFIG[oem] = "-Doem=${LIBPLDM_OEM},-Doem=[],,"
PACKAGECONFIG[oem-ibm] = ""

EXTRA_OEMESON:append = " -Dtests=false"
