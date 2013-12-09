# -*- coding: utf-8 -*-
namespace :Monitor do

  desc "Invalid user info"
  task :count_invalid,[:province]  => :environment do |t, args|
       User.switch_connection_to(params[:province])
       zero_mobile_count = User.where("screen_name is null").count
       CACHE.set "#{:province}_zero_mobile_count" , zero_mobile_count
       zero_contact_count = User.where("(followers_count=? or followers_count is null) and (fans_count=? or fans_count is null) and (weibo_count=? or weibo_count is null)",0,0,0).count
       CACHE.set "#{:province}_zero_contact_count" , zero_contact_count
       zambie_like_count = User.where("(weibo_count=?) = (weibo_count=?)",Date.today.beginning_of_day,10.day.ago.end_of_day).count
       CACHE.set "#{:province}_zambie_like_count" , zambie_like_count 
        
       CACHE.set "#{:province}_max_uid", User.max(uid)
       

  end

end
