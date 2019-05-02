class CreateOpinionWords < ActiveRecord::Migration[5.2]
  def change
    create_table :opinion_words do |t|
      t.string :word
      t.float :score, default: 0.0
      t.integer :positive, default: 0
      t.integer :neutral, default: 0
      t.integer :negative, default: 0
      t.integer :non_opinionated, default: 0
      t.integer :not_a_word, default: 0

      t.timestamps
    end
  end
end
