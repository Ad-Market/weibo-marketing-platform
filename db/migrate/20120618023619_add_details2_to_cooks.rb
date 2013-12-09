class AddDetails2ToCooks < ActiveRecord::Migration
  def change
    add_column :cooks, :owner, :string
  end
end
