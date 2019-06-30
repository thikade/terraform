#!/bin/bash

source secret/env.sh

function fatal {
   echo -e "Error: $*"
   exit 1
}

TODO="Please edit file:  secret/env.sh "

test -z "$TF_VAR_do_token" && fatal "env variable TF_DO_TOKEN not set!\n$TODO\n"
test -z "$TF_VAR_pub_key" && fatal "env variable TF_PUB_KEY_PATH not set!\n$TODO\n"
test -z "$TF_VAR_priv_key" && fatal "env variable TF_PRIV_KEY_PATH not set!\n$TODO\n"


echo "including sensitive variables => ok"

# TF_LOG=INFO | DEBUG | TRACE
export TF_LOG=INFO
export TF_CMD=/c/Apps/terraform/terraform


$TF_CMD init

$TF_CMD plan
#   -var "do_token=${TF_DO_TOKEN}" \
#   -var "pub_key=$TF_PUB_KEY_PATH" \
#   -var "priv_key=$TF_PRIV_KEY_PATH" \
#   -var "ssh_fingerprint=$TF_PUB_KEY_FINGERPRINT"
# 

  
echo -e '\n\nabout to execute TF apply ... (press any key)'
read key
  
$TF_CMD apply  -auto-approve=true
#  -var "do_token=${TF_DO_TOKEN}" \
#  -var "pub_key=$TF_PUB_KEY_PATH" \
#  -var "priv_key=$TF_PRIV_KEY_PATH" \
#  -var "ssh_fingerprint=$TF_PUB_KEY_FINGERPRINT"
#