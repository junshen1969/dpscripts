#!/bin/bash
DP_HOST=$1
DP_PORT=$2
DP_ADMIN=$3
DP_PASS=$4
DOMAIN=$5
NUM_ARGS=$#

display_usage() {
    echo -e "\nUsage:\n $0 dp_host_or_ip dp_ssh_port dp_admin domain\n"
}

main() {
  # check whether user had supplied -h or --help . If yes display usage
  if [[ ( ${NUM_ARGS} == "--help") ||  ${NUM_ARGS} == "-h" ]]; then
    display_usage
    exit 0
  fi
  # if wrong number of  arguments supplied, display usage
  if [[ ${NUM_ARGS} -ne 5 ]]; then
    display_usage
    exit 1
  fi
  local ret_val='';
  list_log_targets
  list_log_targets_file=$ret_val;
  loop_log_targets ${list_log_targets_file}
}

list_log_targets() {

## Generate and execute cmd file begin - *** DO NOT FORMAT THIS ***
local INFILE=${DP_HOST}-${DOMAIN}-list_log_targets.cmd
local OUTFILE=${DP_HOST}-${DOMAIN}-list_log_targets.txt
cat<<EOF >$INFILE
${DP_ADMIN}
${DP_PASS}
switch ${DOMAIN}
show op-state "logging target"
EOF
ssh -p $DP_PORT -T $DP_HOST < $INFILE > $OUTFILE
## Generate and execute cmd file end
  cat $OUTFILE
  ret_val=$OUTFILE
}

show_log_target() {
  log_target_name=$1

## Generate and execute cmd file begin - *** DO NOT FORMAT THIS ***
local INFILE=${DP_HOST}-${DOMAIN}-show_log_target-${log_target_name}.cmd
local OUTFILE=${DP_HOST}-${DOMAIN}-show_log_target-${log_target_name}.txt
cat<<EOF >$INFILE
${DP_ADMIN}
${DP_PASS}
switch ${DOMAIN}
show logging target ${log_target_name}
EOF
ssh -p $DP_PORT -T $DP_HOST < $INFILE > $OUTFILE
## Generate and execute cmd file end

  ret_val=$OUTFILE
}

disable_log_target() {
  log_target_name=$1
  log_target_file=$2

  if [[ $(cat $2 | grep 'type syslog') == *"type syslog"* ]]; then
    echo "Log target is type: syslog"

    if [[ $(cat $2 | grep 'local-address management') == *"local-address management"* ]]; then
      echo "Log target local-address is configured as management"

## Generate and execute cmd file begin - *** DO NOT FORMAT THIS ***
INFILE=${DP_HOST}-${DOMAIN}-disable_log_target-${log_target_name}.cmd
OUTFILE=${DP_HOST}-${DOMAIN}-disable_log_target-${log_target_name}.txt
cat<<EOF >$INFILE
${DP_ADMIN}
${DP_PASS}
switch ${DOMAIN}
co
logging target ${log_target_name}
admin-state disabled
exit
write mem
y
exit
EOF
ssh -p $DP_PORT -T $DP_HOST < $INFILE > $OUTFILE
cat $OUTFILE
## Generate and execute cmd file end
 
      echo 'Disabled log target ' $log_target_name  
    fi
  fi
}

loop_log_targets() {
  while IFS= read -r line; do
    if [[ $line == *"logging target"* ]]; then
      op_state=$(echo $line | awk '{print $3}')
      log_target_name=$(echo $line | awk '{print $5}')
      if [[ $op_state == 'up' ]]; then
        show_log_target $log_target_name
        log_target_file=$ret_val
        disable_log_target $log_target_name $log_target_file
      fi
    fi 
  done < $1
}

main
