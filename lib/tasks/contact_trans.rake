# -*- coding: utf-8 -*-
require 'uri'
namespace :ContactTrans do

  desc "Run Contact info"
  task :hascontact => :environment do |t, args|
  	Baseinfo.where("fans_count is not null").each do |baseinfo|
    		userinfo = baseinfo.userinfo_from_search

		unless userinfo.has_contact
          	  userinfo.has_contact = true
        	  userinfo.save
		  puts 'correct one userinfo'
		end
	end
  end

  desc "Deprated:Run Weibo Crawler"
  task :get_fans_of_user,[:uid] => :environment do |t, args|
    source_uid = args[:uid]
    puts 'uid: ' + source_uid

    crawler = WeiboCrawler.new
    users = crawler.get_fans(source_uid, 200)

    puts 'fans count: ' + users.count.to_s

    # save the first user
    users.each do |user|
      baseinfo = Baseinfo.new
      baseinfo.uid = user['id']
      baseinfo.screen_name = user['screen_name']
      baseinfo.name = user['name']
      baseinfo.province = user['province']
      baseinfo.city = user['city']
      baseinfo.location = user['location']
      baseinfo.description = user['description']
      baseinfo.url = user['url']
      baseinfo.profile_image_url = user['profile_image_url']
      #baseinfo.profile_url = user['profile_url']
      baseinfo.domain = user['domain']
      # baseinfo.weihao = user['weihao']
      baseinfo.gender = user['gender']
      baseinfo.followers_count = user['followers_count']
      baseinfo.friends_count = user['friends_count']
      baseinfo.statuses_count = user['statuses_count']
      baseinfo.favourites_count = user['favourites_count']
      baseinfo.created_at = user['created_at']
      baseinfo.following = user['following']
      baseinfo.allow_all_act_msg = user['allow_all_act_msg']
      baseinfo.geo_enabled = user['geo_enabled']
      baseinfo.verified = user['verified']
      # baseinfo.verified_type = user['verified_type']
      baseinfo.allow_all_comment = user['allow_all_comment']
      baseinfo.avatar_large = user['avatar_large']
      baseinfo.verified_reason = user['verified_reason']
      baseinfo.follow_me = user['follow_me']
      baseinfo.bi_followers_count = user['bi_followers_count']

      begin
        Baseinfo.find(baseinfo.uid)
      rescue Exception
        baseinfo.save
      end
    end
  end

  desc "Run Weibo User Crawler"
  task :get_users_from_cell_page => :environment do |t, args|
    crawler = WeiboPageCrawler.new
    crawler.get_users('31','14','','')
    crawler.get_users_from_keyword('31','14','')
    puts 'OK'
  end

  desc "Run Weibo Contact Info Crawler"
  task :get_contact_infos,[:gen,:province,:city] => :environment do |t, args|
    crawler = ContactInfoCrawler.new
    crawler.get_allinfos(args[:gen],args[:province].to_i,args[:city].to_i)
    #crawler.get_userinfo(2742790143,nil)
    puts 'OK'
  end

end

