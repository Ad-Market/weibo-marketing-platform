class AddCompanyInfoToUserinfoFromSearch < ActiveRecord::Migration
  def change
    add_column :userinfo_from_searchs, :company_info, :string
    add_column :userinfo_from_searchs, :contact_info, :string
    add_column :userinfo_from_searchs, :user_tag, :string
    add_column :userinfo_from_searchs, :user_introduction, :string
    add_column :userinfo_from_searchs, :fans_count, :integer
    add_column :userinfo_from_searchs, :weibo_count, :integer
    add_column :userinfo_from_searchs, :user_authorize, :string
    add_column :userinfo_from_searchs, :user_age, :string
    add_column :userinfo_from_searchs, :user_gender, :string
  end
end
