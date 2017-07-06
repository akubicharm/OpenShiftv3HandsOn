# NFSを利用する場合

## NFS サーバの準備

以下の値は、環境に合わせて適宜編集
NFS 共有するサブネット指定のための環境変数
export NODE_SUBNET="10.0.0.4/24"

NFS_SERVERのホスト名 or IP アドレス
export NFS_SERVER=openshift34


```
yum -y install nfs-utils
```

### NFS 共有するディレクトリの作成
```
mkdir -p /var/export/pvs/pv{1..10}
chown -R nfsnobody:nfsnobody /var/export/pvs
chmod -R 700 /var/export/pvs
```

### NFS 共有の設定
```
for volume in pv{1..10} ; do
echo Creating export for volume $volume;
echo "/var/export/pvs/${volume} $NODE_SUBNET(rw,sync,root_squash)" >> /etc/exports; done;
```

※all_squashから

```
systemctl enable rpcbind nfs-server
systemctl start rpcbind nfs-server nfs-lock nfs-idmap
systemctl stop firewalld
systemctl disable firewalld
```


### SELinuxの設定の変更
```
setsebool -P virt_use_nfs=true;
```


### 確認
```
ssh [クライアントIPアドレス]
mkdir /tmp/test
mount -v $NFS_SERVER:/var/export/pvs/pv1 /tmp/test

umount /tmp/test
exit
```

### PV 定義

```
export volsize=1Gi

for volume in pv{1..10} ; do cat << EOF > ${volume}.yaml
{
"apiVersion": "v1", "kind": "PersistentVolume", "metadata": {
"name": "${volume}" },
"spec": { "capacity": {
"storage": "${volsize}" },
"accessModes": [ "ReadWriteOnce" ], "nfs": {
"path": "/var/export/pvs/${volume}",
"server": "$NFS_SERVER" },
"persistentVolumeReclaimPolicy": "Recycle" }
}
EOF
echo "Created def file for ${volume}"; done;
```


OpenShift のマスターサーバで、OpenShift クラスタ管理者(system:admin)で実行
```
 for f in *.yaml; do oc create -f $f; done
```
