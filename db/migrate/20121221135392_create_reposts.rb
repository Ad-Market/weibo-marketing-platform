# -*- encoding : utf-8 -*-
class CreateReposts < ActiveRecord::Migration
  def up
	   create_table :big_accounts, {:primary_key => :uid, :id => false} do |t|  
	      t.integer :uid, :limit => 8
	      t.string :screen_name
	      t.timestamps
	      t.references :member
	   end

	   create_table :repost_sources, {:primary_key => :wid, :id => false} do |t|  
		t.text :content
		t.string :wid     #weibo id
		t.string :source
		t.datetime :create_time
		t.references :big_account
		t.timestamps
	   end

 	   create_table :repost_contents do |t|
	 	t.references :member
		t.text :content     #评论内容
		t.timestamps
	   end

 end

 def down
    drop_table :big_accounts
    drop_table :reposts
    drop_table :repost_contents
 end
end
