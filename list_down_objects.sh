#!/bin/bash
DP_HOST=$1
DP_PORT=$2
DP_ADMIN=$3
DP_PASS=$4
DOMAIN=$5
NUM_ARGS=$#
INFILE=$DP_HOST-$DOMAIN-opstate.cmd
OUTFILE=$DP_HOST-$DOMAIN-opstate.txt

display_usage() {
    echo -e "\nUsage:\n $0 dp_host_or_ip dp_ssh_port dp_admin dp_pass dp_domain \n"
}

main() {
  # check whether user had supplied -h or --help . If yes display usage
  if [[ ( ${NUM_ARGS} == "--help") || ${NUM_ARGS} == "-h" ]]; then
    display_usage
    exit 0
  fi
  # if not equal to 5 arguments supplied, display usage
  if [[ ${NUM_ARGS} -ne 5 ]]; then
    display_usage
    exit 1
  fi
  local ret_val=''
  showOpstate
  object_list_file=$ret_val
  loop_object_list ${object_list_file=$ret_val}
}

showOpstate() {
INFILE=$DP_HOST-$DOMAIN-opstate.cmd
OUTFILE=$DP_HOST-$DOMAIN-opstate.txt

## Generate cmd file and execute
cat<<EOF >$INFILE
${DP_ADMIN}
${DP_PASS}
switch $DOMAIN;
show op-state;
EOF
ssh -p $DP_PORT -T $DP_HOST < $INFILE > $OUTFILE
ret_val=$OUTFILE
## End
}

loop_object_list() {
  OUTFILE=$DP_HOST-$DOMAIN-list-of-down-objects.txt
  echo "List of objects that are down" > ${OUTFILE}
##  while IFS=$'\n' read -r line; do
  while read -r line; do 
    if [[ "$line" = *"Type"* ]]; then
      echo "$line" >> ${OUTFILE}
    fi
    if [[ "$line" = *"----"* ]]; then
      echo "$line" >> ${OUTFILE}
    fi
    op_state="${line:28:4}"
    admin_state="${line:37:8}"
    if [[ "$op_state" = 'down' ]]; then
      if [[ "${admin_state}" = 'enabled ' ]]; then
        echo "$line" >> ${OUTFILE}
      fi
    fi
  done < $1
  cat $OUTFILE
}

main
