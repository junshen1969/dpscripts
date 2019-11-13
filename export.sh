DOMAIN=default
DP_HOST=$1
DP_PORT=$2
DP_ADMIN=$3
DP_PASS=$4
DOMAIN=$5
SCP_HOST=$6
SCP_USER=$7
SCP_PASS=$8
NUM_ARGS=$#

BACKUP_FILENAME=${DP_HOST}-${DOMAIN}-export.zip

INFILE=${DP_HOST}-${DOMAIN}-export.cmd
OUTFILE=${DP_HOST}-${DOMAIN}-export.txt

display_usage() {
    echo -e "\nUsage:\n $0 dp_host_or_ip dp_ssh_port dp_admin dp_pass dp_domain scp_host scp_user scp_pass\n"
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
  export
}


## Export configuration from Source DataPower
export() {

## Generate cmd file and execute
cat<<EOF >$INFILE
${DP_ADMIN}
${DP_PASS}

switch $DOMAIN;
co;
backup $BACKUP_FILENAME $DOMAIN;
copy export:///${BACKUP_FILENAME} scp://${SCP_USER}@${SCP_HOST}/${BACKUP_FILENAME};
${SCP_PASS}

delete export:///${BACKUP_FILENAME}

EOF
ssh -p $DP_PORT -T $DP_HOST < $INFILE > $OUTFILE
cat $OUTFILE
## End

}

main
