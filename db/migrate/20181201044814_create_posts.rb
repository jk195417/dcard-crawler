class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
		  t.integer :dcard_id
		  t.integer :reply_id
		  t.integer :comment_count
      t.integer :comments_count
		  t.integer :like_count
		  t.string :title
		  t.string :tags
		  t.string :topics
		  t.string :forum_name
		  t.string :forum_alias
		  t.string :gender
		  t.string :school
		  t.string :department
		  t.string :reply_title
      t.text :excerpt
		  t.text :reactions
		  t.text :custom_style
		  t.text :media
		  t.boolean :anonymous_school
		  t.boolean :anonymous_department
		  t.boolean :pinned
		  t.boolean :with_nickname
		  t.boolean :hidden
		  t.boolean :with_images
		  t.boolean :with_videos
      t.timestamps
    end

    add_index :posts, :dcard_id, unique: true
    add_reference :posts, :forum
  end
end
