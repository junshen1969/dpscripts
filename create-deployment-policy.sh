DOMAIN=default
DP_PORT=2022
DP_HOST=172.16.102.114
DP_ADMIN=admin
DP_PASS=Passw0rd!

## Create deployment policies in Target DataPower
## Create import package in Target DataPower
## Import configuration to Target DataPower
INFILE=${DP_HOST}-${DOMAIN}-create-deployment-policy.cmd
OUTFILE=${DP_HOST}-${DOMAIN}-create-deployment-policy.txt
cat<<EOF >$INFILE
${DP_ADMIN}
${DP_PASS}

switch $DOMAIN;
co;
deployment-policy "WP_Deployment_Policy"
  filter */default/access/snmp
  filter */default/config/deployment
  filter */default/mgmt/rest-mgmt
  filter */default/mgmt/ssh
  filter */default/mgmt/telnet
  filter */default/mgmt/web-mgmt
  filter */default/mgmt/xml-mgmt
  filter */default/network/dns
  filter */default/network/host-alias
  filter */default/network/interface
  filter */default/network/link-aggregation
  filter */default/network/network
  filter */default/network/nfs-client
  filter */default/network/nfs-dynamic-mounts
  filter */default/network/nfs-static-mount
  filter */default/network/ntp-service
  filter */default/network/smtp-server-connection
  filter */default/network/vlan
  filter */default/system/system
  filter */default/access/username
exit;

import-package "WP_Import_Package"
  source-url "temporary:///${BACKUP_FILENAME}"
  import-format ZIP
  overwrite-files
  overwrite-objects
  deployment-policy WP_Deployment_Policy
  local-ip-rewrite
  no auto-execute
exit;
write mem;
y

EOF

ssh -p $DP_PORT -T $DP_HOST < $INFILE > $OUTFILE
cat $OUTFILE

