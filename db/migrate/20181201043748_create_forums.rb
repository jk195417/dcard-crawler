class CreateForums < ActiveRecord::Migration[5.2]
  def change
    create_table :forums do |t|
      t.string :dcard_id
      t.string :alias
      t.string :name
		  t.string :description
		  t.string :title_placeholder
		  t.string :subcategories
		  t.string :topics
		  t.integer :subscription_count
      t.integer :posts_count
		  t.boolean :is_school
		  t.boolean :can_post
		  t.boolean :invisible
		  t.boolean :fully_anonymous
		  t.boolean :can_use_nickname
		  t.boolean :should_categorized
		  t.boolean :nsfw
      t.timestamps
    end
    
    add_index :forums, :dcard_id, unique: true
    add_index :forums, :alias, unique: true
    add_index :forums, :name, unique: true
  end
end
