# Dcard 爬蟲

學術用途。

爬取 Dcard 上的文章與留言做數據分析。

## 使用說明

1.  安裝 `ruby` (有的人可以跳過這個步驟)

    參考 <https://www.ruby-lang.org>

2.  安裝 `bundler` (有的人可以跳過這個步驟)

    ```bash
    $ gem install bundler
    ```

3.  安裝 `Postgres` (有的人可以跳過這個步驟)

    參考 <https://www.postgresql.org/download/>

4.  安裝 `Redis` (有的人可以跳過這個步驟)

    參考 <https://redis.io/download#installation>

5.  下載此專案

    ```bash
    $ git clone https://github.com/jk195417/dcard-crawler.git
    $ cd dcard-crawler
    ```

6.  安裝 `ruby` 外部函式庫

    ```bash
    $ bundle install
    ```

7.  設置與資料庫的連線

    ```env
    # 把 `config/.env.example` 改成 `config/.env`，填入 DB_USERNAME DB_PASSWORD 與 REDIS_URL
    DB_USERNAME='db username'
    DB_PASSWORD='db password'
    REDIS_URL='redis://$ip:$port/$db'
    ```
    ```bash
    # 執行主程式
    $ rake run

    # 執行命令列模式
    $ rake run:c

    # 執行 sidekiq
    $ sidekiq -C config/sidekiq.yml -r ./bootstrap.rb
    ```
