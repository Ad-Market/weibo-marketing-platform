class AddPermissionsToMembers < ActiveRecord::Migration
  def change
    add_column :members, :export_permission, :boolean, :default => false
  end
end
