class CreateBaseinfos < ActiveRecord::Migration
  def change
    create_table :baseinfos, :id => false, :primary_key => :uid do |t|
      t.integer :uid, :limit => 8
      t.string :screen_name
      t.string :name
      t.string :province
      t.string :city
      t.string :location
      t.string :description
      t.string :url
      t.string :profile_image_url
      t.string :domain
      t.string :gender
      t.integer :followers_count
      t.integer :friends_count
      t.integer :statuses_count
      t.integer :favourites_count
      t.datetime :created_at
      t.boolean :following
      t.boolean :allow_all_act_msg
      t.string :remark
      t.boolean :geo_enabled
      t.boolean :verified
      t.boolean :allow_all_comment
      t.string :avatar_large
      t.string :verified_reason
      t.boolean :follow_me
      t.integer :bi_followers_count
      t.string :email
      t.string :qq
      t.string :msn

      t.timestamps
    end
  end
end
