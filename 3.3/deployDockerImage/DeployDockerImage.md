# Docker Imageを利用したデプロイ
Docker Image を利用して、アプリケーションをデプロイします。

**目的**  
- Security Context Constraints
- Service Account
- Policy  
を理解する。

## Policy の設定
```
oadm policy add-scc-to-group anyuid system:serviceaccounts:<PROJECT_NAME>
```

## アプリケーションのデプロイ
1. 管理Webにログイン
https://<利用環境のURL> にアクセス

2. プロジェクトの作成
「New Project」ボタンをクリックしてプロジェクト作成ウィザードを開始。

3. プロジェクト名の設定
「New Project」画面で、Name フィールドに「imageapp」と入力し、「Create」ボタンをクリック。

4. デプロイ方式の選択
「Add to Project」画面上部のタブで「Deploy Image」を選択
![./deployImageTab.png](./deployImageTab.png)

5. コンテナイメージを選択
外部のDocker Registryのpull specを指定し、虫眼鏡のアイコンをクリック。  
ImageName: `docker.io/jboss/wildfly`  
コンテナイメージが見つかると、詳細情報が表示される。
![wildfly image](./wildflyimage.png)

6. アプリケーションのデプロイ
画面下部の「Create」ボタンをクリック

7. デプロイの確認
「Next Steps」画面で`Continue to overview`のリンクをクリック

8. ルート作成
Image 指定のビルドでは、クライアントからアクセスするためのルートがないので、「Create Route」をクリックしてルートを作成
![wildfly pod](./wildflypod.png)

|名前|値|
|---|---|
|Name|wildfly(デフォルトのまま）|
|Hostname|（入力なし）|
|Path|（入力なし）|
|Service|wildfly（デフォルトのまま）|
|Target Port|8080->8080(TCP)（デフォルトのまま）|
Hostnameを指定しない場合は**<アプリケーション名>-<プロジェクト名>.<デフォルトのサブドメイン名>**  でURLが生成される。

9. アプリケーションにアクセス
「Overview」画面に表示された URL をクリックしてアプリケーションにアクセス
