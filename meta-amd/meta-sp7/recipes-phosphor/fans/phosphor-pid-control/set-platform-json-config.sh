#!/bin/bash

set -e

board_id=$(/usr/sbin/fw_printenv -n board_id)

# Set softlink for platform dependent config.json file
case "$board_id" in
   "82"|"83"|"87")  # Morocco board_ids
        ln -sf /usr/share/swampd/morocco-stepwise-config.json /usr/share/swampd/config.json
   ;;
   *)  # Default stop phosphor-pid-control.service
        rm -f /usr/share/swampd/config.json
        systemctl stop phosphor-pid-control.service
   ;;
esac
