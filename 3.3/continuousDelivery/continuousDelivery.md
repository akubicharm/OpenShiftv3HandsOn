# 継続的デリバリー

![CD](cd.jpg)

## Container Image
コンテナイメージが作成されリポジトリに登録されるときは、
* namespace
* name
* tag
* imageのメタデータ
が付与される。

![tagschema](./tagschema.jpg)

## Image Stream
Image Streamは、コンテナイメージへの参照。

![imagestream](./imagestream.jpg)

![tag_step1](./tag_step1.jpg)

![tag_step2](./tag_step2.jpg)

### 参照可能なオブジェクト
* OpenShiftのビルダーでビルドした同一プロジェクト内のコンテナイメージ
* 他の Image Stream
* 外部のDocker Registry で配布されている Docker Image

### タグ
コンテナイメージに付与するラベル。


## Image Stremの管理
1. CLI で OpenShift にログイン
```
oc login https://<管理WebのURL>:8443
```

2. helloci プロジェクトの選択
```
oc project helloci
```

3. プロダクション用のタグ付け  
helloci プロジェクトの Image Stream に、プロダクション用のタグを付与
```
oc get is
oc tag helloci/world:latest helloci/world:prod
```

## プロダクション用のプロジェクト作成
1. 管理Webにログイン
`https://<利用環境のURL>`にアクセス

2. プロジェクトの作成  
「New Project」ボタンをクリックしてプロジェクト作成ウィザードを開始。

3. プロジェクト名の設定  
「New Project」画面で、Name フィールドに「imageapp」と入力し、「Create」ボタンをクリック。

4. デプロイ方式の選択  
「Add to Project」画面上部のタブで「Deploy Image」を選択
![./deployImageTab.png](./deployImageTab.png)

5. Image Streamの選択  
hellociのプロジェクトで作成された `helloci/world:prod`のImage Streamを指定  
**ここで、policy設定のコマンドが表示される**

6. ポリシーの設定  
表示されたポリシー設定コマンドをコピーして、CLI で実行
```
oc policy add-role-to-user system:image-puller system:serviceaccount:hellocd:default -n helloci
oc policy add-role-to-user view [USERNAME]-n helloci
```

7. アプリケーションのデプロイ  
「Create」ボタンをクリックしてアプリケーションのデプロイ

8. Routeの作成  
「Create Route」のリンクをクリックしてRouteを作成

## アプリケーションの更新
1. 管理WebでOverviewの表示  
変更の反映が目視できるように、hellociプロジェクトのoverviewを表示
2. index.php を編集
3. 変更をコミット

## Image Streamの更新
1. CLI で OpenShift にログイン
```
oc login https://<管理WebのURL>:8443
```

2. helloci プロジェクトの選択
```
oc project helloci
```

3. ImageStreamの確認
```
oc get is
oc describe is world
```

4. 管理WebでOverviewの表示  
変更の反映が目視できるように hellocd プロジェクトのOverviewを表示

5. プロダクション用のタグ付け  
helloci プロジェクトの Image Stream に、プロダクション用のタグを付与
```
oc get is
oc tag helloci/world:latest helloci/world:prod
```


http://developerblog.redhat.com/2016/01/13/a-practical-introduction-to-docker-container-terminology/
