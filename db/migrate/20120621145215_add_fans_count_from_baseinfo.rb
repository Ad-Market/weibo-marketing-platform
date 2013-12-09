class AddFansCountFromBaseinfo < ActiveRecord::Migration
  def change
    add_column :baseinfos, :fans_count, :integer
    add_column :baseinfos, :weibo_count, :integer
    add_column :baseinfos, :school,:string
    add_column :baseinfos, :job,:string
    add_column :baseinfos, :birthday,:string
  end
end
