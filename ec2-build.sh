#!/bin/sh
set -x

ARN="arn:aws:iam::123412341234:role/foo"
BUCKET="<puppet-bucket>"

USER='root'
if [ `whoami` != $USER ]; then
    sudo -u $USER -H $0 "$@"
    exit $?
fi

sleep 15

apt-get update
apt-get --yes --force-yes install puppet python-pip
pip install awscli # awscli included with Ubuntu 14.04 is old

# This section is needed only if the puppet bucket is located in a different account
TMP=`/bin/mktemp`
aws sts assume-role \
    --role-arn $ARN \
    --role-session-name "RoleSession1" \
    | grep -w 'AccessKeyId\|SecretAccessKey\|SessionToken' \
    | awk  '{print $2}' \
    | sed  's/\"//g;s/\,//' > $TMP
export AWS_ACCESS_KEY_ID=`sed -n '3p' $TMP`
export AWS_SECRET_ACCESS_KEY=`sed -n '1p' $TMP`
export AWS_SECURITY_TOKEN=`sed -n '2p' $TMP`
rm -f $TMP
# end assume-role section

until \
    aws s3 sync --delete s3://$BUCKET/puppet/ /etc/puppet/ && \
    /usr/bin/puppet apply /etc/puppet/manifests/mainrun.pp ; \
do sleep 5 ; done
