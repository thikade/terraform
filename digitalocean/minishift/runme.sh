#!/bin/bash

ENV_FILE=secret/env.sh

function fatal {
   echo -e "Error: $*"
   exit 1
}


test ! -f $ENV_FILE && fatal "env.sh not found!\nSee example: secret/example_env.sh\n"
source $ENV_FILE

TODO="Please edit file:  secret/env.sh "
test -z "$TF_VAR_do_token" && fatal "env variable TF_VAR_do_token not set!\n$TODO\n"
test -z "$TF_VAR_pub_key" && fatal "env variable TF_VAR_pub_key not set!\n$TODO\n"
test -z "$TF_VAR_priv_key" && fatal "env variable TF_VAR_priv_key not set!\n$TODO\n"

echo "including sensitive variables => ok"

# TF_LOG=INFO | DEBUG | TRACE
# export TF_LOG=INFO
# i'm using TF for Windows ...
export TF_CMD=/c/Apps/terraform/terraform


$TF_CMD init

$TF_CMD plan
  
echo -e '\n\nabout to execute TF apply ... (press any key)'
read key
  
$TF_CMD apply  -auto-approve=true
