class RemoveAvatarLargeFromBaseinfo < ActiveRecord::Migration
  def up
    remove_column :baseinfos, :avatar_large, :name , :profile_image_url,:friends_count,:created_at,:following,:allow_all_act_msg,:geo_enabled,:allow_all_comment,:verified_reason,:follow_me,:bi_followers_count,:favourites_count,:statuses_count
   end

  def down
    add_column :baseinfos, :avatar_large, :string
  end
end
