# マルチテナント

Project を跨いだServiceの利用と制限。

## ログイン
1. 監理Webにログイン  
`https://<利用環境のURL>`にアクセス。

## PHPアプリケーションのデプロイ
1. プロジェクトの作成
「New Project」ボタンをクリックして、プロジェクト作成ウィザードを開始。

2. プロジェクト名の設定
「New Project」画面で Name フィールドに「webapp」と入力し、「Create」ボタンをクリック。

3. PHPの選択
テンプレート一覧から「php:5.x -Latest」を選択。
**x はその時の最新の数字に読み替えてください。2016/12/7時点では「php:5.6 -latest」**

4. Podの作成
「NameフィールドにNameフィールドに「world」、Git Repository URLに`https://github.com/akubicharm/hello-php`と入力し、「Create」ボタンをクリック。

5. ビルドとデプロイの確認  
「Next Steps」画面で`Continue to overview`のリンクをクリック。

## データベースのデプロイ
1. プロジェクトの作成
「New Project」ボタンをクリックして、プロジェクト作成ウィザードを開始。

2. プロジェクト名の設定
「New Project」画面で Name フィールドに「db1」と入力し、「Create」ボタンをクリック。

3. データベースの選択  
テンプレート一覧から「mysql-ephemeral」を選択。

4. パラメータの設定  
パラメータを設定し、「Create」ボタンをクリック。

|パラメータ|値|
|---|---|
|Database Service Name|hello-php-mysql|
|MySQL Connection Username|myuser|
|MySQL Connection Password|mypass|
|MySQL Databaes Name|mydb|
