class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
			t.integer :post_dcard_id
			t.integer :floor
			t.integer :like_count
      t.string :dcard_id
			t.string :gender
			t.string :school
			t.string :department
			t.string :report_reason
      t.text :content
			t.boolean :anonymous
			t.boolean :with_nickname
			t.boolean :hidden_by_author
			t.boolean :host
			t.boolean :hidden
			t.boolean :in_review
      t.timestamps
    end

    add_index :comments, [:post_dcard_id, :floor], unique: true
    add_reference :comments, :post
  end
end
