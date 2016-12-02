# グループを利用した権限管理
プロジェクトごとに、操作可能なユーザを制限することが可能。

![projectAuth](./projectAuth.jpg)

ポリシーの設定で、可能な操作を制限可能。

![multiuser.jpg](./multiuser.jpg)

ユーザをグループかして、グループに権限を与えることで、開発チーム、運用チームなどの役割分担に合わせて権限を付与することが可能。

![projectGroupUser.jpg](./projectGroupUser.jpg)

## グループとユーザの構成

|PROJECT|NAME|USERS|
|---|---|---|
|todoProd, nodeProd|appAdminGrp|victor|
|ALL|infraAdminGrp|zulu|
|nodePrj, todoDev|devGroup|joe, alice|
|nodeDev|nodeAppGrp|alice, charlie|
|todoDev|todoAppGrp|alice, bob|

## インフラ管理者に OpenShift のクラスタ管理者権限を付与
Master サーバへログインしなくても、基本的な操作ができるように、cluster-admin 権限をインフラ管理者グループに付与。
```
oadm policy add-cluster-role-to-group cluster-admin infraAdminGrp
```

## グループの作成
**グループの作成は管理者用コマンド(oadm)を利用**

1. マスターサーバにsshでログイン  
各サーバの設定にしたがってください。

2. グループの作成
```
oadm groups new appAdminGrp
oadm groups add-users appAdminGrp victor
oadm groups new infraAdminGrp zulu
oadm groups new nodeAppGrp alice charlie
oadm groups new todoAppGrp alice bob
```

## プロジェクトの作成
1. クラスタ管理者で管理サーバへログイン
```
oc login https://<管理サーバのURL> -u zulu
```

2. Node.js アプリケーションのプロジェクト作成
oc new-project nodedev
oc new-project nodeprod

3. Todo アプリケーションのプロジェクト作成
oc new-project tododev
oc new-project todoprod

## 権限の付与
0. クラスタ管理者で管理サーバへログイン
```
oc login https://<管理サーバのURL> -u zulu
```

0. 権限の確認
```
oc describe policyBindings :default -n nodedev
```

0. Todoアプリケーション開発チームに権限の付与  
tododev プロジェクトの管理権限を付与  
```
oc policy add-role-to-group todoAppGrp admin -n tododev
```

0. Node アプリケーション開発チームに権限の付与  
nodedev プロジェクトの管理権限を付与
```
oc policy add-role-to-group nodeAppGrp admin -n nodedev
```

0. インフラ管理者に権限を付与  
Todoアプリケーションの開発プロジェクト、本番プロジェクトの管理権限を付与
```
oc policy add-role-to-group infraAdminGrp admin -n tododev
oc policy add-role-to-group infraAdminGrp admin -n todoprod
```
Nodeアプリケーションの開発プロジェクト、本番プロジェクトの管理権限を付与
```
oc policy add-role-to-group infraAdminGrp admin -n nodedev
oc policy add-role-to-group infraAdminGrp admin -n nodeprod
```

0. アプリケーション管理者に権限を付与
Todoアプリケーションの本番プロジェクトに管理権限を付与
```
oc policy add-role-to-group infraAdminGrp admin -n todoprod
```
Nodeアプリケーションの本番プロジェクトに管理権限を付与
```
oc policy add-role-to-group infraAdminGrp admin -n nodeprod
```

## 権限分掌の確認
```
oc describe policyBindings :default -n nodedev
oc describe policyBindings :default -n nodeprod
oc describe policyBindings :default -n tododev
oc describe policyBindings :default -n todoprod
```
