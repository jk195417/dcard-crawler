# Dcard 爬蟲

學術用途。

爬取 Dcard 上的文章與留言做數據分析。

## Setup

參考 <https://github.com/jk195417/dcard-crawler/wiki#建立實驗環境>

## Usage

1.  安裝 Ruby 外部函式庫

```bash
$ bundle install
```

2.  設置環境變數

```env
# 把 `config/.env.example` 改成 `config/.env`，填入 `DB_USERNAME` `DB_PASSWORD` `REDIS_URL` `BERT_AS_SERVICE_URL`
DB_USERNAME='db username'
DB_PASSWORD='db password'
REDIS_URL='redis://$ip:$port/$db'
BERT_AS_SERVICE_URL='http://0.0.0.0:8125'
```

3.  建立資料庫

```bash
$ rake db:create
$ rake db:schema:load
```

4.  啟動 sidekiq

```bash
$ sidekiq -C ./config/sidekiq.yml -r ./config/boot.rb
```

5.  啟動 Python 3 Virtual Environment

```bash
$ source python3_virtual_environment/bin/activate
```

6.  啟動 bert_as_service

至 <https://github.com/google-research/bert> 下載 model 到 bert_model 資料夾中

```bash
# 執行 bert server (1 worker require 1.4 G RAM, if your GPU have 6 G RAM, you can handle num_worker=4)
$ bert-serving-start -model_dir=../bert_model/multi_cased_L-12_H-768_A-12 -num_worker=4 -http_port=8125 -http_max_connect=20
```

7.  執行

```bash
# 執行主程式
$ rake run
# 下載每個板的資訊
> App::Actions.update_forums
# 下載貼文
> App::Actions.get_posts
# 下載留言
> App::Actions.get_comments
# 計算留言的 word embeddings
> App::Actions.get_comments_embeddings
```
