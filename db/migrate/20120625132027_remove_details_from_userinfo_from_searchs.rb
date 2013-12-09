class RemoveDetailsFromUserinfoFromSearchs < ActiveRecord::Migration
  def up
    remove_column :userinfo_from_searchs, :screen_name
    remove_column :userinfo_from_searchs, :location
    remove_column :userinfo_from_searchs, :followers_count
    remove_column :userinfo_from_searchs, :company_info
    remove_column :userinfo_from_searchs, :contact_info
    remove_column :userinfo_from_searchs, :user_tag
    remove_column :userinfo_from_searchs, :user_introduction
    remove_column :userinfo_from_searchs, :fans_count
    remove_column :userinfo_from_searchs, :weibo_count
  end

  def down
    add_column :userinfo_from_searchs, :screen_name, :string
    add_column :userinfo_from_searchs, :location, :string
    add_column :userinfo_from_searchs, :followers_count, :integer
    add_column :userinfo_from_searchs, :company_info, :string
    add_column :userinfo_from_searchs, :contact_info, :string
    add_column :userinfo_from_searchs, :user_tag, :string
    add_column :userinfo_from_searchs, :user_introduction, :string
    add_column :userinfo_from_searchs, :fans_count, :integer
    add_column :userinfo_from_searchs, :weibo_count, :integer
  end
end
