#!/bin/bash
DP_HOST=$1
DP_PORT=$2
DP_ADMIN=$3
DP_PASS=$4
DOMAIN=$5
INFILE=$DP_HOST-$DOMAIN-opstate.in
OUTFILE=$DP_HOST-$DOMAIN-opstate.out

display_usage() {
    echo -e "\nUsage:\n $0 dp_host_or_ip dp_ssh_port dp_admin dp_pass dp_domain \n"
}


# check whether user had supplied -h or --help . If yes display usage
if [[ ( $# == "--help") ||  $# == "-h" ]]; then
  display_usage
  exit 0
fi
# if not equal to 5 arguments supplied, display usage
if [[ $# -ne 5 ]]; then
  display_usage
  exit 1
fi

cat<<EOF >$INFILE
${DP_ADMIN}
${DP_PASS}
switch $DOMAIN;
show op-state;
EOF

ssh -p $DP_PORT -T $DP_HOST < $INFILE > $OUTFILE
cat $OUTFILE
