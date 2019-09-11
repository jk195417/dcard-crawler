class AddIsScholarToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_scholar, :boolean, default: false
  end
end
