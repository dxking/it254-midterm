#!/bin/bash

# CHANGE THIS TO ONE OF YOUR AWS KEYS BEFORE RUNNING
sshKey='aws'

# grab my local public IP
lPubIp="`curl -s https://checkip.amazonaws.com`/32"
amiID='068663a3c619dd892' # ubuntu 20.04
iCount='1'
iType='t2.micro'
# grab default vpc Id
iVpcId=`aws ec2 describe-vpcs --filters Name=isDefault,Values=true | jq --raw-output '.Vpcs[0].VpcId'`

# create security group and find Id with jq
iSgName="midterm-sg-`head /dev/urandom | tr -dc a-z0-9 | head -c 3`"
iSg=`aws ec2 create-security-group --group-name $iSgName --description 'midterm security group' --vpc-id $iVpcId`
iSgId=`echo $iSg | jq --raw-output '.GroupId'`

# add custom rules to security group to allow ssh/http
aws ec2 authorize-security-group-ingress --group-id $iSgId --protocol tcp --port 22 --cidr $lPubIp
aws ec2 authorize-security-group-ingress --group-id $iSgId --protocol tcp --port 80 --cidr 0.0.0.0/0

# launch ec2 instance and send kickstart.sh to run once instance is up
instance=`aws ec2 run-instances \
--image-id ami-$amiID \
--count $iCount \
--instance-type $iType \
--key-name $sshKey \
--security-group-ids $iSgId \
--user-data file://kickstart.sh`