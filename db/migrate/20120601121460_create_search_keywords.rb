class CreateSearchKeywords < ActiveRecord::Migration
  def change
    create_table :search_keywords do |t|
      t.integer :word_frequency, :limit => 8
      t.integer :search_count
      t.string :keyword
      t.timestamps
    end
  end
end;
