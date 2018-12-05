class AddRemovedToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :removed, :string
  end
end
