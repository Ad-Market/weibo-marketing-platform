class AddDetailsToUserinfoFromSearchs < ActiveRecord::Migration
  def change
    add_column :userinfo_from_searchs, :has_contact, :boolean, :default => false
    add_column :userinfo_from_searchs, :has_name, :boolean, :default => false
  end
end
