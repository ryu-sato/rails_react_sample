# 開発スタートアップ

## 初回

1. git clone ＜このリポジトリ＞
2. VSCodeのdevcontainer開発環境を構築
3. VSCodeから"Open Folder in Container"を選択
4. 依存関係の解決(Gemfile, package.jsonが更新されたら都度実施)
```bash
$ bundle install
$ yarn
```
5. DBの初期化
```bash
$ bin/rails db:create db:migrate db:seed
```
6. 起動
```
$ bin/rails s
```


## 毎回

1. DBのマイグレーション
```bash
$ bin/rails db:migrate
```
2. 起動
```
$ bin/rails s
```
