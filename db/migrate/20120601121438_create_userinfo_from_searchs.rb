class CreateUserinfoFromSearchs < ActiveRecord::Migration
  def change
    create_table :userinfo_from_searchs, :id => false, :primary_key => :uid do |t|
      t.integer :uid, :limit => 8
      t.string :screen_name
      t.string :province
      t.string :city
      t.string :location
      t.integer :followers_count
      t.timestamps
    end
  end
end
