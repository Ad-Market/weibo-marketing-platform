# -*- coding: utf-8 -*-
require 'crawler'
namespace :WeiboCrawler do

  desc "Run Weibo Search Crawler Keyword Version"
  task :search, [:province, :city, :age, :gender, :auth, :kid, :owner] => :environment do |t, args|
    crawler = Crawler::Weibo::Web::Search::UserCrawler.new
    # default parameters
    age = args[:age]=='0'? '18': args[:age].to_s
    gender = args[:gender]=='0'? 'man': args[:gender].to_s
    auth = args[:auth]=='0'? 'ord': args[:auth].to_s
    puts "parameters: #{args[:province]} #{args[:city].to_s} #{age} #{gender} #{auth} #{args[:kid]}"
    # start crawler
    crawler.get_users_from_keyword(args[:province], args[:city], age, gender, auth, args[:kid].to_i, args[:owner])
    puts 'OK'
  end

  desc "Run Weibo Search Crawler Tag Version"
  task :search_by_tag, [:province, :city, :age, :gender, :auth, :tid, :owner] => :environment do |t, args|
    crawler = Crawler::Weibo::Web::Search::UserCrawler.new
    # default parameters
    city = args[:city]=='1000'? 0: args[:city].to_i
    age = args[:age]=='0'? '18': args[:age].to_s
    gender = args[:gender]=='0'? 'man': args[:gender].to_s
    auth = args[:auth]=='0'? 'ord': args[:auth].to_s
    puts "parameters: #{args[:province]} #{args[:city].to_s} #{age} #{gender} #{auth} #{args[:kid]}"
    crawler.get_users_by_tag(args[:province], city, age, gender, auth, args[:tid].to_i, args[:owner])
    puts 'OK'
  end

  desc "Step 1: Run Weibo Contact Info Crawler"
  task :contact,[:limit,:mod_total,:mod_num,:server,:start] => :environment do |t, args|
    User.switch_connection_to(args[:server].to_s)
    crawler = Crawler::Weibo::Web::Home::ContactCrawler.new
    code = crawler.get_contacts(args[:limit].to_i,args[:mod_total].to_i,args[:mod_num].to_i,args[:start],args[:server])
    puts "status code: #{code}" 
  end

  desc "Step 2: Run Weibo Contact Zero Crawler"
  task :zero_contact,[:mod_total,:mod_num,:server,:start] => :environment do |t,args|
    User.switch_connection_to(args[:server].to_s)
    crawler = Crawler::Weibo::Web::Home::ContactCrawler.new
    code = crawler.update_zero_contacts_of_all_province(args[:mod_total].to_i, args[:mod_num].to_i, args[:start].to_i, args[:server])
    puts "status code: #{code}" 
  end

  desc "Step 3: Run Weibo Contact Update Crawler"
  task :update_contact,[:mod_total,:mod_num,:server,:province,:start] => :environment do |t,args|
    User.switch_connection_to(args[:server].to_s)
    crawler = Crawler::Weibo::Web::Home::ContactCrawler.new
    code = crawler.update_all_contacts_of_a_province(args[:mod_total].to_i, args[:mod_num].to_i, args[:province].to_i, args[:start].to_i, args[:server])
    puts "status code: #{code}"
  end

  desc "Step 1: Run Weibo Mobile Crawler"
  task :mobile, [:limit, :mod_total ,:mod_num, :owner, :mode, :province, :start] => :environment do |t, args|
    User.switch_connection_to(args[:province].to_s)
    crawler = Crawler::Weibo::Mobile::Home::InfoCrawler.new
    code = crawler.get_infos(args[:limit].to_i, args[:mod_total].to_i ,args[:mod_num].to_i, args[:owner], args[:mode], args[:start], args[:province])
    puts "status code: #{code}" 
  end

  desc "Step 2: Run Weibo Mobile Empty Crawler"
  task :empty_mobile, [:limit, :mod_total ,:mod_num, :owner, :mode, :province, :start] => :environment do |t, args|
    User.switch_connection_to(args[:province].to_s)
    crawler = Crawler::Weibo::Mobile::Home::InfoCrawler.new
    code = crawler.update_empty_infos(args[:limit].to_i, args[:mod_total].to_i ,args[:mod_num].to_i, args[:owner], args[:mode], args[:start],  args[:province])
    puts "status code: #{code}" 
  end

  desc "crawler for someone's timeline or the update"
  task :timeline => :environment do |t, args|
    BigAccount.order("uid desc").each do |big_account|
      Rails.logger.info("#{Time.now} #{big_account.screen_name}")
      crawler = Crawler::Weibo::Mobile::Home::TimelineCrawler.new
      code = crawler.get_timeline(big_account.uid)
      puts "status code: #{code}" 
    end
  end

end

