# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_02_044320) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer "post_dcard_id"
    t.integer "floor"
    t.integer "like_count"
    t.string "dcard_id"
    t.string "gender"
    t.string "school"
    t.string "department"
    t.string "report_reason"
    t.text "content"
    t.boolean "anonymous"
    t.boolean "with_nickname"
    t.boolean "hidden_by_author"
    t.boolean "host"
    t.boolean "hidden"
    t.boolean "in_review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "post_id"
    t.index ["post_dcard_id", "floor"], name: "index_comments_on_post_dcard_id_and_floor", unique: true
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "forums", force: :cascade do |t|
    t.string "dcard_id"
    t.string "alias"
    t.string "name"
    t.string "description"
    t.string "title_placeholder"
    t.string "subcategories"
    t.string "topics"
    t.integer "subscription_count"
    t.integer "posts_count", default: 0
    t.boolean "is_school"
    t.boolean "can_post"
    t.boolean "invisible"
    t.boolean "fully_anonymous"
    t.boolean "can_use_nickname"
    t.boolean "should_categorized"
    t.boolean "nsfw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alias"], name: "index_forums_on_alias", unique: true
    t.index ["dcard_id"], name: "index_forums_on_dcard_id", unique: true
    t.index ["name"], name: "index_forums_on_name", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.integer "dcard_id"
    t.integer "reply_id"
    t.integer "comment_count"
    t.integer "comments_count", default: 0
    t.integer "like_count"
    t.string "title"
    t.string "tags"
    t.string "topics"
    t.string "forum_name"
    t.string "forum_alias"
    t.string "gender"
    t.string "school"
    t.string "department"
    t.string "reply_title"
    t.text "excerpt"
    t.text "reactions"
    t.text "custom_style"
    t.text "media"
    t.boolean "anonymous_school"
    t.boolean "anonymous_department"
    t.boolean "pinned"
    t.boolean "with_nickname"
    t.boolean "hidden"
    t.boolean "with_images"
    t.boolean "with_videos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "forum_id"
    t.index ["dcard_id"], name: "index_posts_on_dcard_id", unique: true
    t.index ["forum_id"], name: "index_posts_on_forum_id"
  end

end
