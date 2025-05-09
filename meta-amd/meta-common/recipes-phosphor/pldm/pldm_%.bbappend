SRC_URI:amd = "git://github.com/AMDESE/pldm;branch=integ_sp7;protocol=https"
SRCREV:amd = "a162a28a42f6e3654a23efa31c759866d7003cca"

EXTRA_OEMESON:append = " -Doem-ibm=disabled -Doem-ampere=disabled"
