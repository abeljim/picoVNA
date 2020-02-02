#!/bin/bash
# used for uploading the code to the pi and then build it

set -e

curr_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${curr_dir}

pi_addr=$(avahi-resolve-host-name raspberrypi.local -4 | awk '{print $2}')

if [[ -z "${pi_addr}" ]]; then
    exit 1
fi

pi_ssh="pi@${pi_addr}"
ssh -t ${pi_ssh} 'rm -rf ~/rpi' 
scp -r  ../rpi ${pi_ssh}:~
ssh -t ${pi_ssh} 'cd ~/rpi/bluez-5.52 && make && sudo ./gatt_server' 