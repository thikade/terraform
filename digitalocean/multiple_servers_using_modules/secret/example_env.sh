# 
# fill in these values AND rename file to env.sh!
# 

export TF_VAR_do_token=xxx

# used for login to droplet by remote_exec provisioner
export TF_VAR_pub_key=/path/to/public_key.pub   
export TF_VAR_priv_key=/path/to/private_key.pub

# This PUB_KEY will be added to droplet (must already be uploaded to DO before use!)
export TF_VAR_ssh_fingerprint=$(ssh-keygen -E md5 -lf $TF_VAR_pub_key | awk '{print $2}' | cut -d: -f2- )

