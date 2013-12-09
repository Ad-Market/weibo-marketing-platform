class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :url
      t.string:keyword
      t.integer:search_count
      t.integer:city
      t.integer:province
      t.timestamps
    end
  end
end;
