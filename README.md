# background-cat

## 依存
```$ brew install nkf```

```$ brew install wget```

## ファイル実行
実行権限付与
```chmod +x cat_download.sh```
実行
```./cat_download.sh```

## crontab設定
crontabを編集
```crontab -e```

設定ファイルに記述
```分 時 日 月 曜日 コマンド```
毎日8寺0分にcat_download.shを実行
```0 8 * * * <PATH>/cat_download.sh```
バックグラウンドで実行
```分 時 日 月 曜日 コマンド &```
