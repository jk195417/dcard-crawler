學術用途，爬取 Dcard 上的文章與留言做數據分析。

## Setup

參考 <https://github.com/jk195417/dcard-crawler/wiki#建立實驗環境>

Instal rubygems

```sh
$ bundle install
```

Edit credentials

```sh
$ EDITOR="sublime --wait" bin/rails credentials:edit
```

Create PostgreSQL database

```bash
$ rails db:setup
```

### Setup text analysis services (optional)

- Word embeddings https://github.com/jk195417/bert-as-service-starter
- Chinese segmentation https://github.com/jk195417/chinese-segmentation-as-service

## Usage

Rake tasks

```sh
rails dcard:get_comments # 取得已抓取貼文的新留言
rails dcard:get_posts # 持續取得新貼文（非學校）
```

Sidekiq

```sh
$ sidekiq # 20 threads, perform jobs in default queue
$ sidekiq -C ./config/sidekiq_baidu.yml # 5 threads, perform jobs in baidu queue
```
