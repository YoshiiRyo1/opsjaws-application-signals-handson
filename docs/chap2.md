# Chapter 2

## この章の説明

Application Signals を理解するために、シンプルな1つのアプリケーションからシグナルを送信するデモを行います。  
EC2 上で3つのコンテナを立ち上げます。  

app は OpenTelemetry の Java サンプルアプリケーションです。  
ソースコードは [Docs/Language APIs & SDKs/Java/Instrumentation](https://opentelemetry.io/docs/languages/java/instrumentation/) にあります。  
app には [ADOT Java Agent](https://github.com/aws-observability/aws-otel-java-instrumentation/releases) を含めています。  

cw−agent は [CloudWatch Agent](https://gallery.ecr.aws/cloudwatch-agent/cloudwatch-agent) です。  
app から送信したトレースを受け取り、X-Ray 形式に変換して X-Ray へ送信します。  
また、トレースからメトリクスを生成し、[EMF](https://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/monitoring/CloudWatch_Embedded_Metric_Format_Specification.html)  に変換して CloudWatch Logs へ送信します。CloudWatch 側で自動的に CloudWatch Metrics に表示してくれます。    

adot は、[AWS Distro for OpenTelemetry Collector](https://aws-otel.github.io/docs/introduction) です。  
今回の構成では、app から送信されたログを受け取り、CloudWatch Logs へ送信する役割で使用しています。  

![img](./imgs/chap2_diagram.drawio.png)


## dice のビルド

クローンしたリポジトリの `chap2` ディレクトリに移動します。  
```bash
$ cd ~/opsjaws-application-signals-handson/chap2
```

`build` コマンドでアプリケーションをビルドします。  

```bash
$ docker compose build
```

出力からエラーが無いことを確認してください。  

## コンテナ起動

ビルドが正常終了したならば、コンテナを起動します。  

```bash
$ docker compose up -d
$ docker compose ps -a
## STATUS が全て Up になっていることを確認
```

## リクエスト生成

`load_generate.sh` を実行して、app にリクエストを送信します。1回実行で1000リクエストを生成します。  
リクエストが Application Signals に表示されるまで2~3分かかります。その間、何度が実行してみてください。  

```bash
$ chmod +x load_generate.sh 
$ ./load_generate.sh
```

## シグナルの確認

マネジメントコンソールの CloudWatch 画面から、左ペインの **X-Ray トレース** → **トレース** を選択します。  
複数個のトレースが確認できるはずです。  

![xray](./imgs/chap2_xray.png)

トレースの1つをクリックします。詳細画面に遷移します。  
ここでは関連するトレースマップ、トレースとスパン、トレースに関連したログが表示されています。  
該当する API のレスポンスタイムやどの処理が遅いのか、どの処理が呼び出されているのかなどが確認できます。  

![trace](./imgs/chap2_xray_trace.png)  
<br />

子スパンの `RollController.index` をクリックしてみてください。  
概要、リソース、注釈、メタデータ、例外、SQL が表示されます。  
OpenTelemetry SDK、ADOT Java Agent、CloudWatch Agent によって付与された様々なメタデータが表示されています。  
ここを正確に、かつ、詳細に設定することで、トレースの分析が容易になります。  
このデモでは自動計装により様々なメタデータが付与されています。  

![resources](./imgs/chap2_xray_resources.png)  
<br />

マネジメントコンソールの CloudWatch 画面から、左ペインの **Application Signals** → **サービス** を選択します。  
サービス欄に `dice-server` が表示されています。 app コンテナから送信したシグナルが Application Signals まで届いています。  

![applicationsignals](./imgs/chap2_app.png)  
<br />

**dice-server** をクリックすると、サービスの健全性を測るために役立つメトリクスが表示されます。  
特に `サービスオペレーター` タブに表示される情報は SLI として利用可能です。  

![applicationsignals](./imgs/chap2_service.png)  
<br />

CloudWatch Logs を見てみます。  
`/aws/application-signalgs/data` というロググループが作成されています。  
ここに CloudWatch Agent から EMF 形式でメトリクスが送信されています。  

![cwlogs](./imgs/chap2_cwlogs.png)  
<br />

そのメトリクスは CloudWatch Metrics に表示されています。  
カスタム名前空間 `ApplicationSignals` が作られます。Error、Latency、Fault などのメトリクスが表示されています。  

![cwmetrics](./imgs/chap2_cwmetrics.png)  

![metrics](./imgs/chap2_metrices.png)  

## コンテナ停止

コンテナを停止します。  

```bash
$ docker compose down
```

## 解説

Application Signals を利用するためには、以下の2つのコンポーネントが必要です。  

- CloudWatch agent
- AWS Distro for OpenTelemetry

Chapter 2 では、Dockerfile のなかで AWS Distro for OpenTelemetry を組み込んでいます。  
Dockerfile に書かず Docker ボリュームを使う方法もあります。  
これは、いわゆる自動計装エージェントです。アプリケーションコードに手を入れることなく、各シグナルを収集します。  

*dice/Dockerfile*
```Dockerfile
ADD https://github.com/aws-observability/aws-otel-java-instrumentation/releases/download/v1.32.3/aws-opentelemetry-agent.jar ./aws-opentelemetry-agent.jar
```

この jar ファイルをコンテナ環境変数 `JAVA_TOOL_OPTIONS` に設定することで、アプリケーションに対してエージェントを使用可能な状態にできます。  

*compose.yaml*
```
JAVA_TOOL_OPTIONS="-javaagent:/app/aws-opentelemetry-agent.jar"
```

### 環境変数

他にも必要な環境変数があります。これらを正しく構成することで Application Signals にシグナルを送信できます。  

| 環境変数                                                                          | 説明                                                                                                                         |
| --------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| OTEL_TRACES_EXPORTER=otlp                                                         | 必ず `otlp`                                                                                                                  |
| OTEL_LOGS_EXPORTER=otlp                                                           | 本ハンズオンで使用。ログを ADOT へ送信する。Application Signals では使わない。                                               |
| OTEL_METRICS_EXPORTER=none                                                        | 本ハンズオンで使用。Otel のメトリクスは送信しない。                                                                          |
| OTEL_PROPAGATORS=xray,tracecontext,baggage,b3                                     | 分散トレースにおいて後続へ情報を伝達するために使用。Application Signals では `xray` を含める。                               |
| OTEL_RESOURCE_ATTRIBUTES=service.name=dice-server,aws.log.group.names=dice-server | `service.name` はリソース属性を付与。トレース送信元を識別するのに必須。`aws.log.group.names`はトレースとログの紐づけに使用。 |
| OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf                                         | 必ず `http/protobuf`                                                                                                         |
| OTEL_EXPORTER_OTLP_TRACES_ENDPOINT=http://cw-agent:4316/v1/traces                 | CloudWatch Agent をトレース宛先として指定。                                                                                  |
| OTEL_EXPORTER_OTLP_LOGS_ENDPOINT=http://adot:4318/v1/logs                         | 本ハンズオンで使用。ログ宛先。Application Signals では使わない。                                                             |
| OTEL_AWS_APPLICATION_SIGNALS_EXPORTER_ENDPOINT=http://cw-agent:4316/v1/metrics    | CloudWatch Agent をメトリクス宛先として指定。                                                                                |
| OTEL_AWS_APPLICATION_SIGNALS_ENABLED=true                                         | Application Signals を有効。                                                                                                 |
| OTEL_TRACES_SAMPLER=always_on                                                     | トレースのサンプリングをしない。                                                                                             |
| JAVA_TOOL_OPTIONS="-javaagent:/app/aws-opentelemetry-agent.jar"                   | Java 自動計装エージェントのパスを指定。                                                                                      |

[OpenTelemetry compatibility considerations](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Application-Signals-compatibility.html)  

### ログ

本ハンズオンではアプリケーションのログを CloudWatch Logs のロググループ `dice-server` に送信しています。  
ADOT がログを受け取り、CloudWatch Logs へ送信します。  

*otel-config.yaml*
```yaml
exporters:
  awscloudwatchlogs:
    log_group_name: "dice-server"
    log_stream_name: "dice"
    region: "ap-northeast-1"
    log_retention: 7
```

ログにはトレース ID を含めるようにあらかじめ設定しています。  
*dice/logback.xml*
```xml
    <encoder>
      <pattern>%d{HH:mm:ss.SSS} trace_id=%X{AWS-XRAY-TRACE-ID} span_id=%X{span_id} trace_flags=%X{trace_flags} %msg%n</pattern>
    </encoder>
```

コンテナの環境変数  `OTEL_RESOURCE_ATTRIBUTES` に `aws.log.group.names=dice-server` を設定することで、トレースとログを紐づけることができます。  

*compose.yaml*
```
OTEL_RESOURCE_ATTRIBUTES=service.name=dice-server,aws.log.group.names=dice-server
```

X Ray 画面でトレースを見た際に、ログも表示されていたことを思い出してください。  
これらの設定により実現しています。  

- ログにトレース ID を含める
- ログを CloudWatch Logs に送信
- `aws.log.group.names` でロググループを指定 

