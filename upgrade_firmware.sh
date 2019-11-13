#!/bin/bash
DP_HOST=$1
DP_PORT=$2
DP_ADMIN=$3
DP_PASS=$4
DOMAIN=default
IMG_FILE=$5
SCP_HOST=$6
SCP_USER=$7
SCP_PASS=$8
NUM_ARGS=$#

INFILE=$DP_HOST-$DOMAIN-upgrade_firmware.cmd
OUTFILE=$DP_HOST-$DOMAIN-upgrade_firmware.txt

display_usage() {
  echo -e "\nUsage:\n $0 dp_host_or_ip dp_ssh_port dp_admin dp_pass img_file scp_host scp_user scp_pass\n"
}

main() {
  # check whether user had supplied -h or --help . If yes display usage
  if [[ ( ${NUM_ARGS} == "--help") ||  ${NUM_ARGS} == "-h" ]]; then
    display_usage
    exit 0
  fi
  # if wrong number of  arguments supplied, display usage
  if [[ ${NUM_ARGS} -ne 8 ]]; then
    display_usage
    exit 1
  fi
  upgrade_firmware
}

upgrade_firmware() {

## Generate cmd file and execute
cat<<EOF >$INFILE
${DP_ADMIN}
${DP_PASS}
co
copy scp://${SCP_USER}@${SCP_HOST}/${IMG_FILE} image:///${IMG_FILE}
${SCP_PASS}
flash
boot image accept-license ${IMG_FILE}
EOF
ssh -p $DP_PORT -T $DP_HOST < $INFILE > $OUTFILE
cat $OUTFILE
## End

}

main
