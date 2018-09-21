#!/bin/bash
# Creates an EC2 Key Pair for SSH access
# Generates test-instance-config.json from Packer outputs

ARTIFACT_ID=$(cat manifest.json | jq '.builds[0].artifact_id')
IFS=":" read REGION AMI_ID <<< $(sed -e 's/^"//' -e 's/"$//' <<< $ARTIFACT_ID)
DATE=$(date '+%s')
aws ec2 create-key-pair --key-name test-instance-key-${DATE} --query "KeyMaterial" --output text > test-instance-key-${DATE}.pem
echo "{\"Parameters\": {\"AmiId\": \"${AMI_ID}\", \"KeyName\": \"test-instance-key-${DATE}\"}}" >> cfn/test-instance-config.json
