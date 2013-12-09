class AddDetailsToMembers < ActiveRecord::Migration
  def change
    add_column :members, :repost_interval, :integer
    add_column :members, :uid, :integer, :limit => 8
    add_column :members, :utype, :integer, :default=>0 # 0=>member, 1=>weibo ...
    add_column :members, :search_permission, :boolean
    add_column :members, :comm_permission, :boolean
    add_column :members, :lbs_permission, :boolean
    add_column :members, :repost_permission, :boolean
    add_column :members, :ads_permission, :boolean
  end
end
