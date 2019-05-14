class CreateSentiments < ActiveRecord::Migration[5.2]
  def change
    create_table :sentiments do |t|
      t.float :positive
      t.float :confidence
      t.float :negative
      t.integer :sentiment
      t.references :sentimental, polymorphic: true, index: true
      t.timestamps
    end
  end
end
