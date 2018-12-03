class ChangeForumPostDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:forums, :posts_count, 0)
    change_column_default(:posts, :comments_count, 0)
  end
end
