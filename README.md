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
$ rails antusd:load
```

### Setup text analysis services (optional)

- Word embeddings https://github.com/jk195417/bert-as-service-starter
- Chinese segmentation https://github.com/jk195417/chinese-segmentation-as-service

## Usage

Rake tasks

```sh
$ rails dcard:get_forums
$ rails dcard:get_posts
$ rails dcard:get_comments
$ rails remove:useless_comments
$ rails remove:useless_posts
$ rails antusd:reload
$ rails bert:get_comments_embeddings # require https://github.com/jk195417/bert-as-service-starter
```

Sidekiq

```sh
$ rails sidekiq:start

# or
$ sidekiq -C ./config/sidekiq.yml
```
