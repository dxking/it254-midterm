#!/bin/bash
rand=`head /dev/urandom | tr -dc a-z0-9 | head -c 5`
amiId='ami-068663a3c619dd892' # ubuntu 20.04
iSgName="midterm-sg-$rand"
sshKey="aws-$rand"
iCount='1'
iType='t2.micro'
# grab my local public IP in cidr format for hardening instance SSH access
lPubIp="`curl -s https://checkip.amazonaws.com`/32"
# grab default vpc Id
iVpcId=`aws ec2 describe-vpcs --filters Name=isDefault,Values=true | jq --raw-output '.Vpcs[0].VpcId'`
# create security group and find Id with jq
iSg=`aws ec2 create-security-group --group-name $iSgName --description 'midterm security group' --vpc-id $iVpcId`
iSgId=`echo $iSg | jq --raw-output '.GroupId'`

# add custom rules to security group to allow ssh/http
aws ec2 authorize-security-group-ingress --group-id $iSgId --protocol tcp --port 22 --cidr $lPubIp
aws ec2 authorize-security-group-ingress --group-id $iSgId --protocol tcp --port 80 --cidr 0.0.0.0/0

# generate a new aws keypair and ensure correct key permissions
aws ec2 create-key-pair --key-name $sshKey --query 'KeyMaterial' --output text > ~/.ssh/$sshKey.pem
chmod 400 ~/.ssh/$sshKey.pem

# launch ec2 instance and send kickstart.sh to run once instance is up
instance=`aws ec2 run-instances \
  --image-id $amiId \
  --count $iCount \
  --instance-type $iType \
  --key-name $sshKey \
  --security-group-ids $iSgId \
  --user-data file://src/kickstart.sh`

iId=`echo $instance | jq --raw-output '.Instances[0].InstanceId'`
iPubIp=`aws ec2 describe-instances --instance-id $iId| jq --raw-output .Reservations[].Instances[].PublicIpAddress`

echo "Instance Public Ip: $iPubIp"
echo "Instance Private Key: ~/.ssh/$sshKey.pem"

# tag custom resources
aws ec2 create-tags \
  --resources $amiId $iSgId $iId \
  --tags Key=project,Value=midterm