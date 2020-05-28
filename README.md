# it254-midterm
## Criteria:
- Script Starts an EC2 Micro Server
  - Using the aws cli you successfully launch a free tier eligible linux server
- Script adds appropriate firewall rules to security groups
  - using the AWS CLI you add your current external ip to the allowed  section for port 22 in your security group
- Script successfully pushes and executes kickstart file
- Script produces a functional cloud based website
  - by navigating to the automatically generated url or the public ip address you website is viewable over the internet
- Scripts are all commented
  - You script accurately describes what is happening as the script progresses
## Script Use:
Ensure you have proper `~/.aws/credentials` setup. [aws-cli credentials docs](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

From a Linux command line run:
```
git clone https://github.com/dxking/it254-midterm
cd it254-midterm/
chmod +x src/*.sh
src/midterm.sh
```

## SSH Key:
This script will create a keypair and put the private key in: `~/.ssh/aws-xxxxx.pem` (where the x's are a randomly generated string per script run)

### todo:
- auto cleanup of instance and custom resources