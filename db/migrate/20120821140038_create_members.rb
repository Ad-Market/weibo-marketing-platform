class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.string :role
      t.boolean :at_permission
      t.boolean :follow_permission
      t.boolean :platform_permission

      t.timestamps
    end
  end
end
