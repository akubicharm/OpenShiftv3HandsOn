# はじめに

## References
https://access.redhat.com/documentation/en/openshift-enterprise/version-3.0/openshift-enterprise-30-administrator-guide/administrator-guide
Refer Administration Guide to understand install steps in detail.


## Pre-required knowledge
* yum
* git
* ansible
* systemd


## Server topology
* ose3-master.example.com
* ose3-node0.example.com
* ose3-node1.example.com
* ose3-node2.example.com

![Server Topology](images/v3.0ServerStructure_en.png)

CAUTION: ose3-master.example.com and ose3-node0.example.com(Infrastructure Node) appeared as one server in the Administration Guide.

This install guide figure out installation steps using https://github.com/openshift/openshift-ansible.
By the default, htpasswd is used as a authentication methodology.
If you want to change authentication methodology, please refer https://access.redhat.com/beta/documentation/en/openshift-enterprise-30-administrator-guide#configuring-authentication.


---
# Install

Following steps are executed on all servers.


## Confirm environment
* Connectivity to github

Installer connect to github.com to get ImageStream (the template of application). Please confirm connectivity to the github.com.

* /etc/hosts file

To resolve the server IP address, please confirm /etc/host file on both Master and Node server.


## Enable Subscriptions

* User: root
* Server: Master、all Node


    [root@ose3-master ~]# subscription-manager register

    [root@ose3-master ~]# subscription-manager attach

    [root@ose3-master ~]# subscription-manager repos --disable="*"
    [root@ose3-master ~]# subscription-manager repos \
     --enable="rhel-7-server-rpms" \
     --enable="rhel-7-server-extras-rpms" \
     --enable="rhel-7-server-optional-rpms" \
     --enable="rhel-7-server-ose-3.0-rpms"


## Install pckage
* User: root
* Server: Master

## Remove NetworkManager
    [root@ose3-master ~]# yum remove NetworkManager

## Install the following packages
    [root@ose3-master ~]# yum install wget git net-tools bind-utils iptables-services bridge-utils

## Update packages
    [root@ose3-master ~]# yum update


# Install Docker
* User: root
* Server: Master

## Install docker package
    [root@ose3-master ~]# yum install docker

## Edit /etc/sysconfig/docker
Set "OPTIONS" properties 
The --insecur-registry option instructs the docker daemon to trust any Docker registry on the 172.30.0.0/16 subnet, rather than requiring a certificate.

File = /etc/sysconfig/docker


    OPTIONS=--selinux-enabled --insecure-registry 172.30.0.0/16

## Restart docker daemon
    [root@ose3-master ~]# systemctl restart docker


## Confirm docker daemon status
    [root@ose3-master ~]# systemctl status docker
    docker.service - Docker Application Container Engine
       Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled)
       Active: active (running) since 木 2015-07-02 21:03:20 JST; 1h 26min ago
         Docs: http://docs.docker.com
     Main PID: 1152 (docker)
       CGroup: /system.slice/docker.service
               └─1152 /usr/bin/docker -d --selinux-enabled --insecure-registry 172.30.0.0/16 --add-registry registry.access.redhat.com


## Configure DockerStorage
Not necessary for demo.
CAUTION: If you want to measure performance, consider the configuration of storage.

---
# Ensure host access
* User: root
* Server: Master Server

##  generate an SSH key

    [root@ose3-master ~]# ssh-keygen
    Generating public/private rsa key pair.
    Enter file in which to save the key (/root/.ssh/id_rsa):  <- RETURN
    Created directory '/root/.ssh'.
    Enter passphrase (empty for no passphrase):  <- RETURN
    Enter same passphrase again:  <- RETURN
    Your identification has been saved in /root/.ssh/id_rsa.
    Your public key has been saved in /root/.ssh/id_rsa.pub.
    The key fingerprint is:
    72:7e:9c:61:7a:f1:af:f5:c6:ad:7d:c0:b9:c7:77:a3 root@ose3-master
    The key's randomart image is:
    +--[ RSA 2048]----+
    |                 |
    |                 |
    |                 |
    |                 |
    |      . S +  . . |
    |       + + =  +  |
    |        o = . .=.|
    |         o   o.+X|
    |            .E++B|
    +-----------------+


## Distribute your SSH keys
    [root@ose3-master ~]# for host in ose3-master.example.com \
     ose3-node0.example.com \
     ose3-node1.example.com \
     ose3-node2.example.com; \
    do ssh-copy-id -i ~/.ssh/id_rsa.pub $host; \
     done

---
#  Install ansible
* User: root
* Server: Master

##  Enable packages
    [root@ose3-master ~]# yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

## Configure yum repositories
Unable epel yum registory for install ansible.

    [root@ose3-master ~]# sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo

【BEFORE】
    
    [epel]
    name=Extra Packages for Enterprise Linux 7 - $basearch
    #baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch
    mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
    failovermethod=priority
    enabled=1
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

【AFTER】
    
    [epel]
    name=Extra Packages for Enterprise Linux 7 - $basearch
    #baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch
    mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
    failovermethod=priority
    enabled=0
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7


## Install ansible packaage
    [root@ose3-master ~]# yum -y --enablerepo=epel install ansible

## Clonei ansible repositories
Get ansible installer from Github.

    [root@ose3-master ~]# cd ~
    [root@ose3-master ~]# git clone https://github.com/openshift/openshift-ansible
    [root@ose3-master ~]# cd openshift-ansible
    [root@ose3-master ~]# git checkout -b 3.x v3.0.0


## Configure /etc/ansible/hosts
CAUTION: "deployment_type" is necessary.
Please overwrite the following both Master and Node host name with actual FQDN.

File = /etc/ansible/hosts

    # To deploy origin, change deployment_type to origin
    deployment_type=enterprise
    
    # host group for masters
    [masters]
    ose3-master.example.com openshift_hostname="ose3-master.example.com"

    # host group for nodes, includes region info
    [nodes]
    #ose3-master.example.com openshift_node_labels="{'region': 'infra', 'zone': 'default'}"
    ose3-node0.example.com openshift_node_labels="{'region': 'infra', 'zone': 'default'}" openshift_hostname="ose3-node0.example.com"
    ose3-node1.example.com openshift_node_labels="{'region': 'primary', 'zone': 'east'}" openshift_hostname="ose3-node1.example.com"
    ose3-node2.example.com openshift_node_labels="{'region': 'primary', 'zone': 'west'}" openshift_hostname="ose3-node2.example.com"


## Install
    [root@ose3-master ~]# ansible-playbook ~/openshift-ansible/playbooks/byo/config.yml


## Confirm labels
    [root@ose3-master ~]# oc get nodes
    NAME                     LABELS                                                                    STATUS
    ose3-node0.example.com   kubernetes.io/hostname=ose3-node0.example.com,region=infra,zone=default   Ready
    ose3-node1.example.com   kubernetes.io/hostname=ose3-node1.example.com,region=primary,zone=east    Ready
    ose3-node2.example.com   kubernetes.io/hostname=ose3-node2.example.com,region=primary,zone=west    Ready


### Get node properties as YAML
Confirm node labels with `oc get nodes` command.
If `region` and `zone` are not set as a label, please configure the label with `oc edit`.
`oc get nodes` で Node サーバに `region` と `zone` が設定されていない場合、`oc edit` コマンドで追加してください。

### Node for infrastructure : Node0

Add following 2 lines.

    region: infra
    zone: default

CAUTION: Indent has important meanings, please edit carefully.

    [root@ose3-master ~]# oc edit node <node_name> --output='yaml'

【BEFORE】

    apiVersion: v1
    kind: Node
    metadata:
      creationTimestamp: 2015-07-02T21:20:46Z
      labels:
        kubernetes.io/hostname: ose3-node0.example.com

【AFTER】

    apiVersion: v1
    kind: Node
    metadata:
      creationTimestamp: 2015-07-02T21:20:46Z
      labels:
        kubernetes.io/hostname: ose3-node0.example.com
        region: infra
        zone: default


### Node for running container: Node1

Add following 2 lines.

    region: primary
    zone: east

    [root@ose3-master ~]# oc edit node <node_name> --output='yaml'

【BEFORE】

    apiVersion: v1
    kind: Node
    metadata:
      creationTimestamp: 2015-07-02T21:20:46Z
      labels:
        kubernetes.io/hostname: ose3-node1.example.com

【AFTER】

    apiVersion: v1
    kind: Node
    metadata:
      creationTimestamp: 2015-07-02T21:20:46Z
      labels:
        kubernetes.io/hostname: ose3-node1.example.com
        region: primary
        zone: east


### Node for running container: Node2

Add following 2 lines.

    region: primary
    zone: east


    [root@ose3-master ~]# oc edit node <node_name> --output='yaml'

【BEFORE】

    apiVersion: v1
    kind: Node
    metadata:
      creationTimestamp: 2015-07-02T21:20:46Z
      labels:
        kubernetes.io/hostname: ose3-node2.example.com

【AFTER】

    apiVersion: v1
    kind: Node
    metadata:
      creationTimestamp: 2015-07-02T21:20:46Z
      labels:
        kubernetes.io/hostname: ose3-node2.example.com
        region: primary
        zone: west

---
# Configure DNS
This section shows how to configure DNSMasq on "ose3-node0".

Configure DNSMasq on the ose3-node0 (Infrastructure node)
Do NOT install DNSMasq on your master. OpenShift Now has an internal DNS service provided by Go's SkyDNS that is used for internal service communication.

Naming service use both 53/tcp and 53/udp

    [root@ose3-node0 ~]# iptables -I INPUT -p tcp --dport 53 -j ACCEPT
    [root@ose3-node0 ~]# iptables -I INPUT -p udp --dport 53 -j ACCEPT
    [root@ose3-node0 ~]# service iptables save
    [root@ose3-node0 ~]# cat /etc/sysconfig/iptables


#### References.
https://github.com/openshift/training/blob/master/beta-4-setup.md#appendix---dnsmasq-setup


---
# Create Docker Registry
Configure local docker registory to save artifact of Source To Image build.
STIビルドなどで作成した Docker Image を保持するための、Docker Registory を作成する

* User: root
* Server: Master


## Create registry
    [root@ose3-master ~]# oadm registry --config=/etc/openshift/master/admin.kubeconfig \
    --credentials=/etc/openshift/master/openshift-registry.kubeconfig \
    --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'

You can find the following 2 lines.

    deploymentconfigs/docker-registry
    services/docker-registry


## Confirm pods
    [root@ose3-master ~]# oc get pods
    NAME                      READY     REASON    RESTARTS   AGE
    docker-registry-1-2zcdy   1/1       Running   0          5m

## Confirm log
    [root@ose3-master ~]# oc logs docker-registry-1-2zcdy
    time="2015-07-14T07:44:08-04:00" level=info msg="version=v2.0.0+unknown" 
    time="2015-07-14T07:44:08-04:00" level=info msg="redis not configured" instance.id=5783b6dc-8cd1-4aa5-8b6f-7b3399691f15 
    time="2015-07-14T07:44:08-04:00" level=info msg="using inmemory layerinfo cache" instance.id=5783b6dc-8cd1-4aa5-8b6f-7b3399691f15 
    time="2015-07-14T07:44:08-04:00" level=info msg="Using OpenShift Auth handler" 
    time="2015-07-14T07:44:08-04:00" level=info msg="Starting upload purge in 9m0s" instance.id=5783b6dc-8cd1-4aa5-8b6f-7b3399691f15 
    time="2015-07-14T07:44:08-04:00" level=info msg="listening on :5000" instance.id=5783b6dc-8cd1-4aa5-8b6f-7b3399691f15 


### Trouble shooting
When the following error occured, please confirm `/etc/syscnfig/docker` on Node server.
`OPTIONS=--selinux-enabled --insecure-registry 172.30.0.0/16`

    # oc get pods
    NAME                      READY     REASON    RESTARTS   AGE
    docker-registry-1-zzgu8   0/1       image pull failed for registry.access.redhat.com/openshift3/ose-docker-registry:v3.0.0.1, this may be because there are no credentials on this request.  details: (API error (500):  v1 ping attempt failed with error: Get https://registry.access.redhat.com/v1/_ping: dial tcp: i/o timeout. If this private registry supports only HTTP or HTTPS with an unknown CA certificate, please add `--insecure-registry registry.access.redhat.com` to the daemon's arguments. In the case of HTTPS, if you have access to the registry's CA certificate, no need for the flag; simply place the CA certificate at /etc/docker/certs.d/registry.access.redhat.com/ca.crt


## Create test user
    [root@ose3-master ~]# useradd joe
    [root@ose3-master ~]# htpasswd -b /etc/openshift/openshift-passwd joe redhat
    Adding password for user joe


---
# Configure Router
* User: root
* Server: Master

## Dry run creating router
    [root@ose3-master ~]# oadm router --dry-run \
    --credentials='/etc/openshift/master/openshift-router.kubeconfig' \
    --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'

## Scheme for create router
    [root@ose3-master ~]# oadm router <router_name> --replicas=<number> \
    --credentials='/etc/openshift/master/openshift-router.kubeconfig' \
    --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'

    [root@ose3-master ~]# oadm router myrouter --replicas=1 \
    --credentials='/etc/openshift/master/openshift-router.kubeconfig' \
    --selector='region=infra' \
    --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'
    password for stats user admin has been set to OpbX3WGiik
    deploymentconfigs/myrouter
    services/myrouter

## Confirm result
    [root@ose3-master ~]# oadm router myrouter -o yaml \
    --credentials='/etc/openshift/master/openshift-router.kubeconfig' \
    --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'


## Confirm the host which router is deployed on
    [root@ose3-master ~]# oc describe pods myrouter-1-630bf

