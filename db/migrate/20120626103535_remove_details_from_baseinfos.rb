class RemoveDetailsFromBaseinfos < ActiveRecord::Migration
  def up
	  remove_column :baseinfos, :province
    remove_column :baseinfos, :city
    remove_column :baseinfos, :gender
  end

  def down
    add_column :baseinfos, :gender, :string
    add_column :baseinfos, :city, :integer
    add_column :baseinfos, :province, :integer
  end
end
