#!/usr/bin/env sh

regions="us-east-2 us-east-1 us-west-1 us-west-2 ap-northeast-1 ap-northeast-2 ap-northeast-3 ap-south-1 ap-southeast-1 ap-southeast-2 ca-central-1 cn-north-1 cn-northwest-1 eu-central-1"

ACCESS_KEY=""
SECRET_KEY=""

while [[ -z "$ACCESS_KEY" ]]
 do
  echo 'Enter the access key for your account..'
  read ACCESS_KEY
  if [[ -z "$ACCESS_KEY" ]]; then
    echo 'Access key can not be blank..'
  fi
done

while [[ -z "$SECRET_KEY" ]]
 do
  echo 'Enter the secret key for your account..'
  read SECRET_KEY
  if [[ -z "$SECRET_KEY" ]]; then
    echo 'Secret key can not be blank..'
  fi
 done

echo 'Enter the region you are configuring your stack in (same region your AWS CLI is configred to..)'
  read REGION

  match=$(echo "${regions[@]:0}" | grep -o $REGION)
  [[ -z $match ]] && REGION="ap-southeast-2"

echo 'Enter the number of kube nodes you want to configure..'
read NODE_COUNT

sed -i 's/AKEY/'$ACCESS_KEY'/g' terraform-example.tfvars
sed -i 's/SKEY/'$SECRET_KEY'/g' terraform-example.tfvars
sed -i 's/NCOUNT/'$NODE_COUNT'/g' terraform-example.tfvars
sed 's/REGION/'$REGION'/g' terraform-example.tfvars > terraform.tfvars

touch modules/compute/keys/kube.pem
