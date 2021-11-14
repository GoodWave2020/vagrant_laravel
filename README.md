# Laravel用開発環境
## 開発環境の作り方
#### vagrant upの前にやること
- srcディレクトリをマウントする設定のため`git clone [クローン元のURL] src`で現在のディレクトリにクローンしてください。新しくプロジェクトを作成する場合は空のsrcディレクトリを作成してください。
- .envにてipやポートを指定しています。
`vagrant plugin install dotenv`でgemをインストール後、環境変数を読み込めるようにしてください。(sample.envを基に.envを作成してください。)
- provision/provision.envにてMySqlのルートパスワードを設定してください。
#### 入っているもの
- Node.js 16.x
- PHP 7.4
- Redis
- MySql 5.7
- Composer
- Nginx
- git
- zip
#### 各種設定
- provisionディレクトリのnginx, php, php-fpm設定ファイルを使用して初期設定を行います。
- nginxのみconf/nginx/my_nginx.confにて設定ファイルを仮想環境と同期しています。微調整にお使いください。