class CreateDicWords < ActiveRecord::Migration
  def change
    create_table :dic_words do |t|
      t.string :word
      t.timestamps
    end
  end
end;
