#!/bin/bash
DP_HOST=$1
DP_PORT=$2
DP_ADMIN=$3
DP_PASS=$4
DOMAIN=default
NIC=$5
STATE=$6
NUM_ARGS=$#

INFILE=$DP_HOST-$DOMAIN-reboot.cmd
OUTFILE=$DP_HOST-$DOMAIN-reboot.txt

display_usage() {
    echo -e "\nUsage:\n $0 dp_host_or_ip dp_ssh_port dp_admin\n"
}

main() {
  # check whether user had supplied -h or --help . If yes display usage
  if [[ ( ${NUM_ARGS} == "--help") ||  ${NUM_ARGS} == "-h" ]]; then
    display_usage
    exit 0
  fi
  # if wrong number of  arguments supplied, display usage
  if [[ ${NUM_ARGS} -ne 6 ]]; then
    display_usage
    exit 1
  fi
  reboot
}

reboot() {
cat<<EOF >$INFILE
${DP_ADMIN}
${DP_PASS}
  shutdown reboot
EOF
ssh -p $DP_PORT -T $DP_HOST < $INFILE > $OUTFILE
cat $OUTFILE
}

main
