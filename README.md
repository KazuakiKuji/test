# naturali jewelry 2024

## ブランチ構造

- main:本番環境にデプロイされるコードを保持するブランチ
- stg:stg サーバーにデプロイされるコードを保持するブランチ
- develop:機能や修正を統合するブランチ。直接 main へのマージは行わない
- feature:各機能実装や修正のためブランチ。完了したら develop ブランチにマージ
  - 命名規則「feature*[issue 番号]*[作業内容]」
- hotfix:本番環境で起きた緊急のバグ修正を行うブランチ
  - 命名規則「hotfix\_[issue 番号]」

## テーマファイル構造

```sh
/var/www/html/naturali-jewelry/wp-content/themes/NaturaliJuewelry2024
├── assets # 静的アセット (CSS, JavaScript)
│ ├── css
│ │ └── style.css　#　スタイルシート
│ └── js
│ 　 └── main.js 　#　JSコード
├── components # 共通コンポーネント (ナビゲーションバーなど)
│ ├── navbar.php　#　ヘッダー(ナビゲーションバー)テンプレート
│ ├── common.php　#　共通パーツ
│ └── modules # 共通モジュール
│ 　└── module.php
├── config # 設定ファイル
│ ├── app
│ ├── vendor
│ └── ...
├── woocommerce # WooCommerce 関連ファイル
│ ├── single-product.php # テンプレートファイル
│ └── ...
├── index.php # フロントページのテンプレート
├── style.css # テーマ情報記述ファイル
├── functions.php # カスタム関数
├── header.php # headテンプレート
├── footer.php # フッターテンプレート
├── page.php # ページテンプレート
├── 404.php # 404ページのテンプレート
└── ...

```

- 既存の固定ページ、ブログページはそのまま残すため、EC007 からコピーし、新規テーマフォルダへ持ってくる、もしくは同様のファイル名のものを作成する必要あり。
- ec007/woocommerce 以下のファイルで、woocommerce テンプレートとの差異がある場合も新規テーマファイルへ反映する。

## コーディング規約

### ファイル命名規則

- ファイル名はすべて小文字
- ファイルの単語の区切りは\_(アンダースコア)ではなく-(ハイフン)を使用
- ファイル名はファイル内容を説明するものとする
- クラスの記述されているファイルは接頭辞として class-を付ける  
  ex) class-products-search.php

### PHP コーディング規約

#### 関数命名規約

- 関数名はすべて小文字
- 単語の区切りには\_(アンダースコア)を使用
- 引数も関数の命名規則と同様  
  ex ) function original_function_name( $variable_name ) { …}

#### クラス命名規則

- クラス名の各単語は大文字で開始
- 単語の区切り文字は\_(アンダースコア)
- 略語はすべて大文字  
  ex ) class WC_Single_Product { … }

#### 全般

- PHP のショートタグの使用は禁止
- 複数行の PHP タグを埋め込む場合には、PHP タグに１行使用する

```php
//good (複数行)
<?php
	...
?>
//good (単一行)
<input name="<?php echo esc_attr($some_variable); ?>" />

//bad
<? function some_function(){
<div>
	...
</div> }?>
```

- 基本的にシングルクォートを使用  
  ただし、クォート内で評価をする（変数を使用する）場合、ダブルクォートを使用
- 論理演算は厳密な論理演算を使用
- 変数名には意味のある名前を使用
- else if ではなく elseif を使用
- 省略可能な場合でも中括弧で囲む（特に if 文）

参考：[WordPress コーディング規約](https://ja.wordpress.org/team/handbook/coding-standards/wordpress-coding-standards/php/)

### CSS の class、id 命名規則

- １つの要素に対してクラスは１つ（シングルクラス）
- 固定ページにのみ使用される HTML 構造なら、  
  「　 p-固定ページのパス\_\_(アンダースコア２つ)　」を接頭辞とする。
- 共通要素(components 内のファイル)なら、  
  「　 c-コンポーネント名\_\_(アンダースコア２つ)　」を接頭辞とする。
- 単語同士の接合は-(ハイフン)を使用
- 大枠を Block、その中の要素を Element、その中のスタイルを Modifier として命名していく。  
  この際、Block と Element はアンダースコア２つで区切る。（この命名方法を BEM という）  
  ex ) 会社概要ページ(/about)の場合  
  　　 class=”p-about\_\_block\_\_element-modifier”

参考：[BEM の書き方](https://qiita.com/takahirocook/items/01fd723b934e3b38cbbc)

## 各種バージョン（赤色は変更対象）

- OS : FeedBSD 11.2  
  Local 環境では WSL の Ubuntu24.04LTS を使用  
  (OS のバージョンは問題ありませんでした。stg 環境の OS のみ違うみたいです。)
- PHP : 7.4.7→8.2  
  7.4.7 はセキュリティサポート切れ  
  最新は 8.4 だが、Wordpress における安定版は 8.2(例外を除く)
- apache : 2.4.6
- mysql server: 5.7
- WordPress : 6.6

## ファイル管理について ​

- バージョン管理 : GitHub
- STG : さくらのレンタルサーバー

## 設定

1. GitHub に自作テーマファイルをアップロード
   1. アップロードするファイルは、テーマフォルダのみ（theme/my-theme）
2. GitHub Action から、SSH 経由で STG 環境を更新する設定を行う
   1. stg ブランチへの Pull Request をトリガーに反映処理を行う

#### 補足

- テーマフォルダのみアップロードするメリット
  - 画像ファイルなどの膨大なデータを無くし、データ送受信が簡単になる
  - WordPress のコアファイルやプラグインなどを管理しないため、Git を介さないアップデートにも対応できる
- テーマフォルダのみアップロードするデメリット
  - WordPress の core ファイルやプラグインのバージョンアップにより、互換性に齟齬が生じる可能性がある
    - 対策 ①：バージョンを更新したら STG 環境およびローカル環境の更新作業を行う
    - 対策 ②：一度バージョンを更新したら、更新作業を行わない方針で進める
  - 画像ファイルの更新によって、ローカル環境でパス情報などが合わなくなる
    - 対策 ①：画像ファイルの更新とともに、ローカル環境も更新する体制を整える

GitHub に stg 環境アップロード用ブランチ(main とする)を設定  
GitHub Action で、stg ブランチへの Pull Request をトリガーとして、SSH 経由で stg 環境にアップ  
参考：[GitHub Action を用いて FTP 経由で Deploy](https://qiita.com/hoshimado/items/e2073b7a6d40a23cfb55)  
管理するファイルはテーマファイルフォルダのみ（theme/my-theme）  
画像ファイルなどのデータは個々で管理、git では管理しない  
wordpress のバージョンや、各種プラグインのバージョンは個々で管理（自動更新は切る）

## 開発環境構築

### GitHub 設定

1. dreamcareer の GitHub 上にリモートリポジトリを作成
2. theme ファイルを 1 人がアップロード
3. 他の開発者はそのブランチを pull
4. github に SSH 用の github action を設定
5. 個人や機能別にブランチを切る
6. ブランチを編集し、main に対して Pull Request を送る
7. マージし、stg 環境に FTP 経由でアップされているか確認
8. 完了

以降はそれぞれのブランチで作業  
機能が完成し次第 PullRequest を送る
