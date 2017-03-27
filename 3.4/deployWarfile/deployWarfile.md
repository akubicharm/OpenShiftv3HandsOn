# WAR ファイルを使ったアプリケーションのデプロイ
ローカルにあるビルド済みの WAR ファイルを用いてアプリケーションをデプロイします。
オペレーションは CLI から実行します。

**目的**
* ビルド済みの WAR ファイルをデプロイする方法を理解する

## 利用する Docker Image
* jboss-eap64-openshift <registry.access.redhat.com/jboss-eap-6/eap64-openshift>
サンプルのアプリケーションに `https://github.com/openshiftdemos/os-sample-java-web.git
` を利用します。

## Hands-on
### アプリケーションのデプロイ

1. Master へのログイン
```
oc login https://<利用環境のURL>:8443/
```

1. プロジェクトの作成
```
oc new-project wardeploy
```

1. WAR ファイルの取得
```
mkdir -p wardeploy/deployments
cd wardeploy/
curl -o deployments/ROOT.war
-O https://github.com/akubicharm/OpenShiftv3HandsOn/blob/master/3.4/deployWarfile/ROOT.war
```

1. BuildConfig の作成
```
oc new-build jboss-eap64-openshift --name=helloworld --binary=true
```

`oc new-build` のオプションに **--binary=true** を指定すると、 ビルドする際の Source Type をバイナリファイルにするよう強制します。

```
$ oc get bc helloworld
NAME         TYPE      FROM      LATEST
helloworld   Source    Binary    1
```

BuildConfig の Source Type が Binary である場合、`oc start-build` に `--from-file` や `--from-dir` を指定し、標準入力からバイナリファイルを読み込むことでビルドすることができます。

1. ビルドの実行
```
oc start-build helloworld --from-dir=. --follow=true --wait=true
```

ビルドの結果をコンソールに出力するため、`--follow=true` (ビルドのログをトレース) `--wait=true` (ビルドが完了するまで待つ) のオプションを指定しています。
ビルドログの出力例は次のようになります。

```
Uploading directory "." as binary input for the build ...
build "helloworld-1" started
Receiving source from STDIN as archive ...

Copying all war artifacts from /home/jboss/source/. directory into /opt/eap/standalone/deployments for later deployment...
Copying all ear artifacts from /home/jboss/source/. directory into /opt/eap/standalone/deployments for later deployment...
Copying all rar artifacts from /home/jboss/source/. directory into /opt/eap/standalone/deployments for later deployment...
Copying all jar artifacts from /home/jboss/source/. directory into /opt/eap/standalone/deployments for later deployment...
Copying all war artifacts from /home/jboss/source/deployments directory into /opt/eap/standalone/deployments for later deployment...
'/home/jboss/source/deployments/ROOT.war' -> '/opt/eap/standalone/deployments/ROOT.war'
Copying all ear artifacts from /home/jboss/source/deployments directory into /opt/eap/standalone/deployments for later deployment...
Copying all rar artifacts from /home/jboss/source/deployments directory into /opt/eap/standalone/deployments for later deployment...
Copying all jar artifacts from /home/jboss/source/deployments directory into /opt/eap/standalone/deployments for later deployment...

Pushing image 172.30.92.172:5000/wardeploy/helloworld:latest ...
Pushed 0/7 layers, 7% complete
Pushed 1/7 layers, 14% complete
Push successful
```

1. Service の確認
```
oc get svc helloworld
```

1. Route の作成
```
oc expose svc helloworld
```

1. Route の確認
```
oc get route
```

Route が作成されている場合、次のように出力されます。
```
NAME      HOST/PORT                                        PATH      SERVICES   PORT       TERMINATION
app       app-wardeploy.cloudapps-e49d.oslab.opentlc.com             app        8080-tcp   
```

### アプリケーションの動作確認

1. 公開用 URL (Route) への接続

```
curl $(oc get route helloworld --template='{{ .spec.host }}')
```

コンソールの出力例は次のようになります。

```
<html>
<body>
<h2>Hello World with OpenShift!</h2>
</body>
</html>
```

ブラウザでアクセスする場合の URL は `http://<Application ROUTE>/` になります。
