學術用途，爬取 Dcard 上的文章與留言做數據分析。

# Setup

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

# Usage

rake tasks

```sh
$ rails dcard:get_forums
$ rails dcard:get_posts
$ rails dcard:get_comments
$ rails remove:useless_comments
$ rails remove:useless_posts
$ rails sidekiq:start
$ rails bert:get_comments_embeddings
```

sidekiq

```sh
$ rails bert:get_comments_embeddings
# or
$ sidekiq -C ./config/sidekiq.yml
```
