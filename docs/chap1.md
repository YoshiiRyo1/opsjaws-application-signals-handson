# Capter 1

この章は、ハンズオン前の準備を行います。  

## AWS リソースの作成

以下のリソースを作成してください。  

[CloudFormation テンプレート](../cloudformation)を用意しているので、[ドキュメントの手順](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html) を参考にプロビジョニングしてください。

[Terraform](../terraform) も用意しています。

- VPC
  - 既存のものでも新規作成でも構いません
- パブリックサブネット
  - 1つ
  - 既存のものでも新規作成でも構いません
- EC2 インスタンスプロファイル
  - 1つ
  - 付与するポリシーは2つ
    - AmazonSSMManagedInstanceCore
    - CloudWatchAgentServerPolicy
- セキュリティグループ
  - 1つ
  - インバウンドは TCP 8080 を許可
  - アウトバウンドは全て許可
- EC2 インスタンス
  - 1台
  - AMI は以下のいずれか
    - Amazon ECS-Optimized Amazon Linux 2023 (AL2023) x86_64 AMI
  - 上のインスタンスプロファイルとセキュリティグループをアタッチ
  - パブリックサブネットに配置
  - スペック -> 2vCPU, 8GB メモリー以上
  - EBS ボリューム -> 30GB 以上
- CloudWatch Logs ロググループ
  - 2つ
  - グループ名 -> dice-server
  - グループ名 -> petclinic

## EC2 インスタンスへのログイン

Session Manager でログインしてください。

[ログイン手順](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/session-manager-working-with-sessions-start.html)

## ハンズオンの準備

作成した EC2 インスタンスに、リポジトリクローンやパッケージインストールを行います。  

```bash
$ cd ~
$ bash
$ sudo dnf install git zip unzip -y

$ git clone https://github.com/YoshiiRyo1/opsjaws-application-signals-handson.git --depth 1
$ cd opsjaws-application-signals-handson
$ ls

$ chmod +x ./chap1/setup.sh
$ ./chap1/setup.sh
```

上記コマンドを実行したら、一度 Session Manager からログアウトして再度ログインしてください。  


## Application Signals 有効

[CloudWatch](https://ap-northeast-1.console.aws.amazon.com/cloudwatch/home?region=ap-northeast-1#application-signals:services) 画面から、左ペインの **Application Signals** → **サービス** を選択します。  
初回アクセス時には以下のボタンが表示されます。**サービスの検出を開始** をクリックしてください。  

![alt text](./imgs/chap1_enable.png)


自分のアカウントでこのステップを初めて完了すると、**AWSServiceRoleForCloudWatchApplicationSignals** サービスリンクロールが作成されます。
このロールの詳細については、[CloudWatch Application Signals のサービスリンクロールのアクセス許可](https://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/monitoring/using-service-linked-roles.html#service-linked-role-signals) を参照してください。  
