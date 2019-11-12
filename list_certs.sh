DOMAIN=apiconnect
DPPORT=2022
DPHOST=172.16.102.114
INFILE=$DOMAIN.in
OUTFILE=$DOMAIN.out

cat<<EOF >$INFILE
admin
Passw0rd!
switch $DOMAIN;
show certificate;
EOF
ssh -p $DPPORT -T $DPHOST < $INFILE >> $OUTFILE
#cat $OUTFILE

while IFS= read -r line
do
  echo "$line"
done < "$OUTFILE"
