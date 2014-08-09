yqbin-relay
===========

リモートサーバからローカルPCに命令をRelayするため、JSONファイルを以下に作成するスクリプト  
```
/tmp/yq-bin_order.json
```
中身はJSON形式のオーダーデータ  
```例
[{"ID":"6","USERNAME":"test","START":"Apple","GOAL":"Apple","DATE":"2014-08-09 16:33:59","TEMP":null}]
```

初期設定
=======

* 初期設定
```
$ make build
```

操作説明
========

* 起動  
```
$ sudo /bin/sh ~/yqbin/yq-bin_checker.sh start
```
* 停止  
```
$ sudo /bin/sh ~/yqbin/yq-bin_checker.sh stop
```
* 再起動  
```
$ sudo /bin/sh ~/yqbin/yq-bin_checker.sh restart
```

出力ログ
=======

* エラーログ  
```
/tmp/yq-bin_checker.err
```
* 標準ログ
```
/tmp/yq-bin_checker.out
```
