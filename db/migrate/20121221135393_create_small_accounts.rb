# -*- encoding : utf-8 -*-
class CreateSmallAccounts < ActiveRecord::Migration
  def up

	   create_table :small_accounts do |t|
	      t.integer :uid, :limit => 8
	      t.string :password
	      t.string :name
	      t.integer :status, :default => 1#记录是否有效 默认1为有效 -1无效
	      t.string :content #原因备注
	      t.datetime :last_repost_time
	      t.references :big_account
	      t.timestamps
	   end
   

 end

 def down
    drop_table :small_accounts
 end
end
