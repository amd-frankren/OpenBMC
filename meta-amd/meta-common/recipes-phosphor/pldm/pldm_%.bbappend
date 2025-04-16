SRC_URI:amd = "git://github.com/AMDESE/pldm;branch=integ_sp7;protocol=https"
SRCREV:amd = "059fc8922b5fc26f35fbe219dd64369552c14bfb"

EXTRA_OEMESON:append = " -Doem-ibm=disabled -Doem-ampere=disabled"
