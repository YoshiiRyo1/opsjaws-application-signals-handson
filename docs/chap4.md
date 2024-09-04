# クリーンアップ

[Chapter 1](./chap1.md) で作成したリソースを削除します。
CloudFormation で作成した場合は CloudFormation コンソールから作成したスタックを指定して削除してください。

Chapter 3 で Synthetic Canary を作成している場合は、それも削除します。  
削除手順は [Chapter 3](./chap3.md) に記載がありますが、念の為以下にも記載します。  
また、CloudWatch 画面を開いて Canary が消えていることを確認してください。  

```bash
$ cd ~/opsjaws-application-signals-handson/chap3
$ ./create-canaries.sh ap-northeast-1 delete $ENDPOINT
```

CloudWatch Logs を削除します。  
以下の他にも作成したロググループがあれば削除してください。  

- /aws/application-signals/data
- dice-server
- petclinic
- /aws/lambda/cwsyn*

CloudWatch アラームを削除します。  


<br />

[目次へ戻る](./README.md)  