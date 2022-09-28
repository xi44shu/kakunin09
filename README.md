# アプリケーション名
CCS (Current Construction Schedule)

# アプリケーション概要
- 工事の予約管理ができます

- 現状の予約状況を共有できます

# URL
https://kakunin09.herokuapp.com/

# テスト用アカウント
- Basic認証ID：admin
- Basic認証パスワード：2222
- 名前：テスト
- パスワード：test00
- Email：test@00

# 利用方法
## チーム登録機能
1. トップページのヘッダーからユーザー新規登録もしくはログインを行います

2. トップページのヘッダーから班一覧のリンク先へ移動します

3. 班一覧画面から新規班作成のリンク先へ移動します

4. 班名・所属の入力、稼働状態（稼働中か休み）の選択をした状態で「登録する」を押します

5. 稼働中が選択された班に対して工事の予約（プルダウンリストで選択）ができるようになります

## 工事予約機能
1. トップページのヘッダーからユーザー新規登録を行う

2. トップページもしくは新規予約のリンク先から、予約登録を行う

3. 必須項目の全てを、該当するものを選択した状態で「登録ボタン」を押す

# アプリケーションを作成した背景
前職の時、工事の予約管理が紙ベースで行われていました。

外出中は、最新の予約状況が把握できないため、つど問い合わせをする必要がありました。

問い合わせのコスト・伝達ミスを減らすため、外出時でも最新状況が確認できる予約管理のアプリケーションを開発することにしました。

# 洗い出した要件
https://docs.google.com/spreadsheets/d/1iHOls9Kz-P6k_k65_rZjHxKLZwUrB6q9XcHaKZRXZgo/edit#gid=982722306

# 実装した機能についての画像やGIFおよびその説明
[![Image from Gyazo](https://i.gyazo.com/0fc95339cf44b4a19331588fe4d47291.gif)](https://gyazo.com/0fc95339cf44b4a19331588fe4d47291)

入力フォームの"登録する"を押すと下の一覧表に予約が反映されます

# 実装予定の機能
- 予約した工事の検索機能の実装

# データベース設計
![オリジナルアプリER-kakunin09 drawio (1)](https://user-images.githubusercontent.com/110109166/192133954-58527187-7c36-4567-9750-0a7c02678fc0.png)

# 画面遷移図
![オリジナルアプリ画面遷移 (1)-kakunin09画面遷移のコピー drawio (2)](https://user-images.githubusercontent.com/110109166/192134864-f1bbd343-e3eb-4810-88ff-972ad1d38aec.png)

# 開発環境
- Ruby 2.6.5
- Ruby on Rails 6.0.0
- MySQL
- Github
- Visual Studio Code

# ローカルでの動作方法
以下のコマンドを順に実行

% https://github.com/xi44shu/kakunin09.git

% cd kakunin09

% bundle install

% yarn install

% rails db:create

% rails db:migrate

# 工夫したポイント
- 入力の手間を減らす工夫
  - 電話に出ながら片手で操作できるよう、予約に必須の項目は文字入力を無くしました
  - 班の状態(稼働中/休み)によって、一覧表に表示される班が変動するようにしました

# 
