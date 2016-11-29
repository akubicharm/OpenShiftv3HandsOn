# 複雑なアプリケーションのデプロイ
ウェブアプリケーションとデータベースの連携

**目的**
サービスを理解する

## PHPとMySQLの連携
同一プロジェクト内のPodは、サービス名を利用して参照します。  
サービス名は`[service name]_SERVICE_HOST`という環境変数で参照可能。hello-php-mysqlの場合は、`HELLO_PHP_MYSQL_SERVICE_HOST`となります。
![PHP-MySQL](./PHP-MySQL.jpg)

## 利用するコンポーネント
* php:5.x (Latestとなっているテンプレートを利用)
* mariadb-ephemeral(永続化ストレージを利用しない　MariaDB)

サンプルアプリケーションは`https://github.com/akubicharm/hello-php`を利用します。

## アプリケーションのビルドとデプロイ

###プロジェクトの作成
1. 管理Webにログイン  
`https://<利用環境のURL>:8443`にアクセス。

2. プロジェクトの作成  
「New Project」ボタンをクリックして、プロジェクト作成ウィザートを開始。

3. プロジェクト名の設定  
「New Project」画面でNameフィールドに「hello」と入力し、「Create」ボタンをクリック。

### PHPアプリケーションのビルドとデプロイ
4. PHPの選択  
テンプレート一覧から「php:5.x - Latest」を選択。

5. Pod作成  
Nameフィールドに「world」、Git Repository URLに`https://github.com/akubicharm/hello-php`と入力し、「Create」ボタンをクリック

6. ビルドとデプロイの確認  
「Next Steps」画面で`Continue to overview`のリンクをクリック。

7. ビルドログ確認  
「View Log」のリンクをクリックし、ビルドログを確認。

8. アプリケーションの動作確認  
管理Webの左側のペインの「Overview」タブをクリックして、プロジェクトの概要を表示。右側のペインでアプリケーションの公開URLをクリックし、アプリケーションにアクセス。  
**ここでは、データベースが設定されていなのでPHPのエラーメッセージが表示される**
![PHP Error](./php-error.png)

### データベースのデプロイ

1. コンポーネントの追加  
管理Webのプロジェクト名の右隣の「Add to project」ボタンをクリック。

2. データベースの選択  
テンプレート一覧から「mysql-ephemeral」を選択。

3. パラメータの設定  
パラメータを設定し、「Create」ボタンをクリック。

|パラメータ|値|
|---|---|
|Database Service Name|hello-php-mysql|
|MySQL Connection Username|myuser|
|MySQL Connection Password|mypass|
|MySQL Databaes Name|mydb|

### PHP Podの環境変数の設定
1. デプロイメントコンフィグの選択

管理webの左側のペインで「Applications->Deployments」を選択し、右側のペインのDeployments一覧から「world」を選択。

2. 環境変数の設定
管理Webの右側のペインで「Environment」タブを選択。Environment画面で環境変数を設定し、「Save」ボタンをクリック。

|Name|Value|
|---|---|
|MYSQL_USER|myuser|
|MYSQL_PASSWORD|mypass|
|MYSQL_DATABASE|mydb|

**PHPのPodが再起動される**

3. アプリケーションの動作確認
