class DropOpinionWords < ActiveRecord::Migration[5.2]
  def change
    drop_table :opinion_words
  end
end
