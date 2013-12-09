class AddDetails3ToCooks < ActiveRecord::Migration
  def change
    add_column :cooks, :remark, :string
  end
end
