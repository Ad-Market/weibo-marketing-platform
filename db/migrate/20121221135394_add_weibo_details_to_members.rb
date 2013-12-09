class AddDetailsToMembers < ActiveRecord::Migration
  def change
    add_column :members, :weibo_name, :string
    add_column :members, :token, :string
    add_column :members, :expires_at, :datetime
    add_column :members, :avatar, :string
    add_column :members, :money, :float
  end
end
