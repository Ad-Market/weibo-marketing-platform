class AddDetailsToCooks < ActiveRecord::Migration
  def change
    add_column :cooks, :username, :string, :unique => true
    add_column :cooks, :passwd, :string
    add_column :cooks, :frequent, :boolean
    add_column :cooks, :forbidden, :boolean
  end
end
