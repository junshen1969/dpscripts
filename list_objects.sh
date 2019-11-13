#!/bin/bash
DP_HOST=$1
DP_PORT=$2
DP_ADMIN=$3
DP_PASS=$4
DOMAIN=$5
OBJNAME=$6
NUM_ARGS=$#

INFILE=$DP_HOST-$DOMAIN-list_object-${OBJNAME}.cmd
OUTFILE=$DP_HOST-$DOMAIN-list_objects-${OBJNAME}.txt

display_usage() {
  echo -e "\nUsage:\n $0 dp_host_or_ip dp_ssh_port dp_admin dp_pass dp_domain dp_object[key|certificate|...]\n"
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
  list_objects
}


list_objects() {

## Generate cmd and execute
cat<<EOF >$INFILE
${DP_ADMIN}
${DP_PASS}
switch $DOMAIN;
show ${OBJNAME};
EOF
ssh -p $DP_PORT -T $DP_HOST < $INFILE >> $OUTFILE
cat $OUTFILE
## End

}

main
