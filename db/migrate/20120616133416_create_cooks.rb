class CreateCooks < ActiveRecord::Migration
  def change
    create_table :cooks do |t|
      t.text :content
      t.boolean :expired
      t.string :page_type
      t.string :uid

      t.timestamps
    end
  end
end
