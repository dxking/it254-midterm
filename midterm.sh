#!/bin/bash

# grab my local public IP
lPubIp="`curl -s https://checkip.amazonaws.com`/32"
sshKey='aws'
amiID='068663a3c619dd892'
iCount='1'
iType='t2.micro'
iVpcId='vpc-64b8b41e'

# create security group and find Id with jq
iSgName="midterm-sg-`head /dev/urandom | tr -dc a-z0-9 | head -c 3`"
iSg=`aws ec2 create-security-group --group-name $iSgName --description 'midterm security group' --vpc-id $iVpcId`
iSgId=`echo $iSg | jq --raw-output '.GroupId'`
# add custom rules to security group
aws ec2 authorize-security-group-ingress --group-id $iSgId --protocol tcp --port 22 --cidr $lPubIp
aws ec2 authorize-security-group-ingress --group-id $iSgId --protocol tcp --port 80 --cidr 0.0.0.0/0

# launch ec2 instance
aws ec2 run-instances \
--image-id ami-$amiID \
--count $iCount \
--instance-type $iType \
--key-name $sshKey \
--security-group-ids $iSgId \
--user-data file://kickstart.sh
