# Instant Appのデプロイ

OpenShiftのテンプレートを利用して、インスタントアプリケーションをデプロイします。

**目的**
プロジェクト、アプリケーション作成の方法を理解する

## アプリケーションのビルドとデプロイ
1. 管理Webにログイン  
`https://<利用環境のURL>` にアクセス。

2. プロジェクトの作成  
「New Project」ボタンをクリックしてプロジェクト作成ウィザードを開始。

3. プロジェクト名の設定  
「New Project」画面でNameフィールドに「firstapp」と入力し、「Create」ボタンをクリック。  

4. インスタントアプリケーションを選択  
テンプレートから「nodejs-example」を選択。

5. 作成  
画面下部の「Create」ボタンをクリック。

6. ビルドとデプロイの確認  
「Next Steps」画面で`Continue to overview`のリンクをクリック。

7. ログ確認  
「View Log」のリンクをクリックし、ビルドログを確認。

![ViewLog](./ViewLog.png)

最後に`Push successful`と表示されていれば、Docker Imageの作成とDocker Registoryへの登録が完了
![BuildLog_PushImage](./BuildLog_PushImage.png)

8. アプリケーションの動作確認  
管理Webの左側のペインの「Overview」タブをクリックして、プロジェクトの概要を表示。
右側のペインのアプリケーションの公開URLをクリックし、アプリケーションにアクセス。

![FirstApp](./firstapp.png)

## 管理Webの利用
### Podの確認
![FirstAppPod](./firstapp-pod.png)
Podのアイコンをクリックし、Podの詳細情報を表示

## レプリケーションコントローラの動作確認
### スケールアップとダウン
Podアイコン右の「^」Podをスケールアップ

### セルフヒーリング
Podアイコンをクリックし、Pod一覧からPodを選択。画面右上の「Actions」プルダウンから「Delete」を選択して、Podを削除。

削除したPodの状態が「Running」->「Terminating」となり、最終的に一覧から削除される。その代わり、新たなPodが起動される。
