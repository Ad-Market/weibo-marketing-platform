class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.integer :id
      t.integer :city_id
      t.integer :province_id
      t.string :name

      t.timestamps
    end
  end
end
