# Warファイルのデプロイ
JBoss EAPに、ビルド済みのWARファイルをデプロイします。

## アプリケーションのビルド
1. CLI でログイン
```
oc login https://<利用環境のURL>:8443
```

2. プロジェクトの作成
```
oc new-project wardeploy
```

3. JBoss EAP をデプロイ
```
oc new-app jboss-eap64-openshift:latest~. --name app
```
このコマンドでは、カレントディレクトリのソースコードを指定して、appという名前でJBoss EAPをデプロイしている。
利用可能な ImageStream は `oc get is -n openshift`で確認

## WAR ファイルのデプロイ
1. WARファイルのデプロイ
```
oc start-build app --from-file=jboss-kitchensink.war
```

## Routeの作成
1. サービスの確認
```
oc get svc
```

2. Routeの作成
```
oc expose svc app
```

3. Routeの確認
```
oc get Route
$ oc get route
NAME      HOST/PORT                                        PATH      SERVICES   PORT       TERMINATION
app       app-wardeploy.cloudapps-e49d.oslab.opentlc.com             app        8080-tcp   
```

## アプリケーションの確認
1. ブラウザでアクセス
`http://<Application ROUTE>/jboss-kitchensink`
