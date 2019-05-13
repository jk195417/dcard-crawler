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

create Postgres database

```bash
$ rails db:setup
```

Load opinion words from ANTUSD dic: `lib/ANTUSD/opinion_words.csv`

```bash
$ rails antusd:load # 讀取 ANTUSD
```

### Setup text analysis services (optional)

- Word embeddings https://github.com/jk195417/bert-as-service-starter
- Chinese segmentation https://github.com/jk195417/chinese-segmentation-as-service

## Usage

Rake tasks

```sh
rails dcard:get_comments # 取得已抓取貼文的新留言
rails dcard:get_posts # 持續取得新貼文（非學校）
rails dcard:remove:useless_comments # 刪除 已經被移除 / 空白內容 的留言
rails dcard:remove:useless_posts # 刪除 沒有留言 / 已經被移除 / 留言數太少 的貼文
rails dcard:update_forums # 更新所有論壇
rails antusd:reload # 重新讀取 ANTUSD
# require https://github.com/jk195417/bert-as-service-starter
rails bert:get_comments_embeddings # 取得 沒有計算過文字向量且內容不是空白的留言 的文字向量
```

Sidekiq

```sh
$ sidekiq
```
