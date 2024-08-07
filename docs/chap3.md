# Chapter 3

Chapter 3では複数のマイクロサービスのシグナルを受信し、そのなかから SLO を定義します。  

## マイクロサービスのビルド

クローンしたリポジトリの `chap3` ディレクトリに移動します。  
```bash
$ cd chap3
```

Docker イメージをビルドします。  

```bash
$  ./mvnw clean install -PbuildDocker 
```


## コンテナ起動

ビルドが正常終了したならば、コンテナを起動します。  

```bash
$ docker compose up -d
$ docker compose ps -a
## STATUS が全て Up になっていることを確認
```

5分待ちます。  


## Application Insights の確認

マネジメントコンソールの CloudWatch 画面から、左ペインの **X-Ray トレース** → **トレース** を選択します。  
Chapter 2同様に複数個のトレースが確認できるはずです。  

## SLI 表示

マネジメントコンソールの CloudWatch 画面から、左ペインの **Application Signals** → **サービス** を選択します。  

いくつかのサービスが表示されます。  

![services](./imgs/chap3_services.png)

**customers-server** をクリックしてみましょう。  

**概要** タブでは、サービスの健全性を一覧で確認できます。  

続いて **サービスオペレーション** タグを開きます。  
HTTP メソッドと API Endpoint の組み合わせでレイテンシー、リクエスト数、エラー数を確認できます。
ここを SLI として利用します。  

![service_operations](./imgs/chap3_serviceoperation.png)  

## SLO 作成

それでは SLO を作りましょう。  

**サービスオペレーション** 画面のままです。  
`PUT /owners/{ownerId}` の横の **SLO を作成** をクリックします。  

### 名称

任意の名称を入力します。今回は「cutomer-put-owners」としました。  

![alt text](./imgs/chap3_slo_name.png)

### SLI

SLI を設定します。  
条件を可用性、または、レイテンシーから選択します。可用性の場合は率(％)、レイテンシーの場合はミリ秒で設定します。  

期間は評価する期間です。  

下部に説明文が表示されています。今回の例で良好とみなさせる条件です。  
実際はここを自分が管理しているサービスに最適なものにしてください。  

> 1 分 期間中、PUT /owners/{ownerId} 可用性 が 次以上: に対して 99.9% である場合、customers-server のサービスレベルは良好かつ正常であるとみなされます。

![alt text](./imgs/chap3_slo_sli.png)

### SLO

SLO を設定します。  
ローリング、または、カレンダーから間隔を選択します。今回は「30日、ローリング」にします。  

達成目標は読んだままですね。間隔で設定した期間中、正常健全であると判定される目標値を設定します。  

警告のしきい値は、CloudWatch アラーム発報条件に使用できます。  

ここも下部に説明文が表示されています。SLO らしい説明です。  

> 99.9% の目標は、30 ローリング 日 の間隔 内における 可用性 次未満: 99.9% で 43 分 を超えない場合に達成されます。これにより、エラーバジェットは 43 分 となります。ここで、可用性 は30 ローリング 日 の間隔 における 次未満: 99.9% です。

![alt text](./imgs/chap3_slo_slo.png)

### CloudWatch アラーム

CloudWatch アラームを設定します。説明不要かなと思います。  

![alt text](./imgs/chap3_slo_alarm.png)

## 様々な SLO

前の手順を参考にして様々な SLO を作成してみましょう。  

- レイテンシーが 3ms 以下であること (99パーセンタイル)
- 7日ローリング、目標は99%

- レイテンシーが 10ms 以下であること (90パーセンタイル)
- ローリング期間を変えて3つの SLO を作ってみる
  - 7日ローリング、目標は99%
  - 30日ローリング、目標は99%
  - 365日ローリング、目標は99%


## コンテナ停止

一通りの検証が完了したらコンテナを停止します。  

```bash
$ docker compose down
```


## Thanks

このハンズオンは [spring-petclinic-microservices](https://github.com/spring-petclinic/spring-petclinic-microservices/tree/main) のマイクロサービス群を利用しています。ありがとうございます。  

