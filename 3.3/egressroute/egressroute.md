# Egress Router
外部アクセスする場合の、送信元IPアドレスを統一する。

## 準備
### 送信元IPアドレスの確保
Node サブネット上の使われていないIPアドレス

### ゲートウェイのIPアドレスの確認
デプロイ先のNodeから接続先サーバへ接続するためのGatewayのIPアドレスを確認する。
例えば、IPアドレスが 104.199.239.163 のサーバへアクセスするためのゲートウェイは以下のコマンドで確認できる。

```
# ip route get 104.199.239.163
104.199.239.163 via 192.168.0.2 dev eth0  src 192.168.0.101
    cache

```

### 接続先IPアドレスの確認
単一の送信元IPアドレスでアクセスしたいサーバのIPアドレスを確認し、`site=springfield-1`というラベルを付与する。

### Nodeへのラベル付与
Egress Router のデプロイ先を特定するために、Nodeにラベルを付与する。

Nodeのラベルを確認する。  
ユーザ `system:admin`
```
# oc get nodes --show-labels
NAME                     STATUS                     AGE       LABELS
infranode1.example.com   Ready                      2d        beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,env=infra,kubernetes.io/hostname=infranode1.example.com,region=infra,zone=default
master1.example.com      Ready,SchedulingDisabled   2d        beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=master1.example.com
node1.example.com        Ready                      2d        beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,env=dev,kubernetes.io/hostname=node1.example.com,region=primary,zone=one
node2.example.com        Ready                      2d        beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,env=dev,kubernetes.io/hostname=node2.example.com,region=primary,zone=two
node3.example.com        Ready                      2d        beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,env=prod,kubernetes.io/hostname=node3.example.com,region=primary,zone=three

# oc label node node3.example.com site=springfield-1
```

## egress routerのデプロイ

### Pod定義ファイルの作成
PodをデプロイするためのYAMLファイルを作成する。
site=springfield-1 というラベルのついたNodeにデプロイされるように`nodeSelector`でNodeを指定する。

[egressroute.yaml]
```
apiVersion: v1
kind: Pod
metadata:
  name: egress-1
  labels:
    name: egress-1
  annotations:
    pod.network.openshift.io/assign-macvlan: "true"
spec:
  containers:
  - name: egress-router
    image: openshift/origin-egress-router
    securityContext:
      privileged: true
    env:
    - name: EGRESS_SOURCE
      value: 192.168.0.99
    - name: EGRESS_GATEWAY
      value: 192.168.0.2
    - name: EGRESS_DESTINATION
      value: 104.199.239.163
  nodeSelector:
    site: springfield-1
```

### サービス定義ファイルの作成
サービスを作成するためのYAMLファイルを作成。

[egressservice.yaml]
```
apiVersion: v1
kind: Service
metadata:
  name: egress-1
spec:
  ports:
  - name: http
    port: 80
  - name: https
    port: 443
  type: ClusterIP
  selector:
    name: egress-1
```

### Podとサービスのデプロイ
ユーザ `system:admin`
```
oc new-project egress
oc create -f egressroute.yaml
oc create -f egresssservice.yaml
```
### 動作確認
ちゃんと外部接続する用のアプリケーションをデプロイすれば良いのですが、ここでは簡易的にpythonのコンテナをデプロイして、curl でアクセスを確認する。

egressプロジェクトにWebUIかCLIを使って、アプリケーションのコンテナをデプロイする。

```
# oc get pods
NAME                           READY     STATUS      RESTARTS   AGE
egress-1                       1/1       Running     0          12m
python-1-ogb5r                 1/1       Running     0          1h

oc rsh python-1-ogb5r
curl -k https://$EGRESS_1_SERVICE_HOST:$EGRES_1_SERVICE_PORT_HTTPS
```
