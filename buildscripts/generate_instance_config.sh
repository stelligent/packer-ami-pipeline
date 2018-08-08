#!/bin/bash
# Generate test-instance-config.json from Packer outputs

ARTIFACT_ID=$(cat manifest.json | jq '.builds[0].artifact_id')
echo $ARTIFACT_ID
echo $(sed -e 's/^"//' -e 's/"$//' <<< $ARTIFACT_ID)
IFS=":" read REGION AMI_ID <<< $(sed -e 's/^"//' -e 's/"$//' <<< $ARTIFACT_ID)
echo "Region: ${REGION}"
echo "AMI ID: ${AMI_ID}"
DATE=$(date '+%s')
aws ec2 create-key-pair --key-name test-instance-key-${DATE} --query "KeyMaterial" --output text > test-instance-key-${DATE}.pem
echo "{\"AmiId\": \"${AMI_ID}\", \"KeyName\": \"test-instance-key-${DATE}\"}" >> test/test-instance-config.json