# Capter 1

この章は、ハンズオン前の準備を行います。  

## AWS リソースの作成

以下のリソースを作成してください。  

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
  - インバウンドはルール無し
  - アウトバウンドは全て許可
- EC2 インスタンス
  - 1台
  - AMI は以下のいずれか
    - Amazon ECS-Optimized Amazon Linux 2023 (AL2023) x86_64 AMI
  - 上のインスタンスプロファイルとセキュリティグループをアタッチ
  - パブリックサブネットに配置
  - スペック -> 2vCPU, 8GB メモリー以上
  - EBS ボリューム -> 20GB 以上
- CloudWatch Logs ロググループ
  - 2つ
  - グループ名 -> dice-server
  - グループ名 -> petseach


Terraform も用意しています。[こちら](../terraform)。  
手動でも Terraform でもお好きな方法で作成してください。  

## リポジトリのクローン

作成した EC2 インスタンスに、ここのリポジトリをクローンしてください。  

## Docker Compose インストール




## Application Signals 有効

[CloudWatch](https://ap-northeast-1.console.aws.amazon.com/cloudwatch/home?region=ap-northeast-1#application-signals:services) 画面から、左ペインの **Application Signals** → **サービス** を選択します。  
初回アクセス時には以下のボタンが表示されます。**サービスの検出を開始** をクリックしてください。  

![alt text](./imgs/chap1_enable.png)


自分のアカウントでこのステップを初めて完了すると、**AWSServiceRoleForCloudWatchApplicationSignals** サービスリンクロールが作成されます。
このロールの詳細については、[CloudWatch Application Signals のサービスリンクロールのアクセス許可](https://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/monitoring/using-service-linked-roles.html#service-linked-role-signals) を参照してください。  

