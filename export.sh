DOMAIN=default
DP_PORT=2022
DP_HOST=172.16.102.114
DP_ADMIN=admin
DP_PASS=Passw0rd!

SCP_HOST=172.16.102.160
SCP_USER=khongks
SCP_PASS=Passw0rd!

BACKUP_FILENAME=${DOMAIN}-export.zip

INFILE=${DP_HOST}-${DOMAIN}-export.in
OUTFILE=${DP_HOST}-${DOMAIN}-export.out

## Export configuration from Source DataPower
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
