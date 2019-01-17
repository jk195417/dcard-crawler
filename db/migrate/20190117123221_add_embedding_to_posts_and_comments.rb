class AddEmbeddingToPostsAndComments < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :embedding, :float, array: true
    add_column :comments, :embedding, :float, array: true
  end
end
