class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.integer :echo_chamber

      t.timestamps
    end

    add_column :users, :reviews_count, :integer, default: 0
    add_column :posts, :reviews_count, :integer, default: 0
  end
end
