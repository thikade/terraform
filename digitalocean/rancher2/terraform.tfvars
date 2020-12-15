
remote-exec-all-nodes = [
              # "setenforce 0",
              # "sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config",
              # "echo 'remote-exec user commands executed' >  /tmp/remote-exec.log",
              ]

fingerprints =   [
      "77:0d:a0:e6:ad:19:cd:fb:3a:ff:44:0f:6b:a7:07:0d",    ## ansible pub-key
      "4f:7d:cf:c6:82:38:0a:19:11:ad:42:5a:b5:7d:66:9e",    ## default: my pub-key
    ]

projectName = "Rancher"

nodeCount = 1

tagList = [ "rancher-node", "FW-PRIVATE" ]

droplet-size = "s-2vcpu-4gb"

nodeNames = [
  "rancher1",
  "rancher2",
  "rancher3",
  "rancher4",
  "rancher5",
  "rancher6",
  "rancher7",
  "rancher8",
  "rancher9",
]
