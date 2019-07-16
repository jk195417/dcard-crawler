class DropReviews < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :reviews, :posts
    remove_foreign_key :reviews, :users
    remove_column :posts, :reviews_count
    remove_column :users, :reviews_count
    drop_table :reviews
  end
end
