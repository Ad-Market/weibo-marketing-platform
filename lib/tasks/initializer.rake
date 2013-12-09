# -*- coding: utf-8 -*-
namespace :Initializer do
  desc "clear all cookies"
  task :clear_all_cookies => :environment do |t, args|
    # 清理所有cookie
    Cook.all.each do |cook|
      cook.destroy
    end
    puts "cookie清理完毕"
  end

  desc "split account into many pieces"
  task :split_accounts => :environment do |t, args|
    file = File.open("weibo-account/500.txt")
    provinces = ["beijing","guangdong","zhejiang","jiangsu"]
    split_line = [130,260,380,500]
    output_files = [
      File.open("weibo-account/" + provinces[0],"w"),
      File.open("weibo-account/" + provinces[1],"w"),
      File.open("weibo-account/" + provinces[2],"w"),
      File.open("weibo-account/" + provinces[3],"w")]
    province_index = 0
    file.readlines.each_with_index do |account,index|
      puts index.to_s
      if index == split_line[province_index]
        province_index += 1
      end

      if province_index == 0
        owner_id = (index)/10+1
      else
        owner_id = (index-split_line[province_index-1])/10+1
      end
      output_files[province_index].print provinces[province_index] + owner_id.to_s + " " + account
    end
    output_files.each do |output|
      output.close
    end
  end

  desc "add cookies to the group with less than 10 accounts"
  task :add_cookies_to_group,[:filename] => :environment do |t, args|
    filepath = "weibo-account/" + args[:filename]
    file = File.open(filepath)
    accounts = []
    file.readlines.each do |account|
      accounts << {
        :username => account.split[0],
        :password => account.split[1]
      }
    end
    account_pointer = 0
    provinces = ["shanghai", "beijing", "guangdong", "zhejiang", "jiangsu"]
    provinces.each do |province|
      Cook.switch_connection_to(province)
      owners = Cook.select("owner").where("page_type=?","web").group("owner")
      owners.each do |owner|
        if owner.owner != "contact"
          count_of_cook_in_db = Cook.where("owner = ? and page_type = ? and frequent = ?", owner.owner, "web", false).count
          puts "#{owner.owner}组需要导入#{10-count_of_cook_in_db}个帐户"
          (10-count_of_cook_in_db).times do
            if account_pointer < accounts.count
              # web cookie
              cookie = Cook.new
              cookie.username = accounts[account_pointer][:username]
              cookie.passwd = accounts[account_pointer][:password]
              cookie.owner = owner.owner
              cookie.expired = true
              cookie.frequent = false
              cookie.remark = ""
              cookie.content = ""
              cookie.page_type = "web"
              cookie.save
              # mobile cookie
              cookie = Cook.new
              cookie.username = accounts[account_pointer][:username]
              cookie.passwd = accounts[account_pointer][:password]
              cookie.owner = "mobile0826"
              cookie.expired = true
              cookie.frequent = false
              cookie.remark = ""
              cookie.content = ""
              cookie.page_type = "mobile"
              cookie.save
              # increase
              puts "#{accounts[account_pointer][:username]}已经被导入到#{owner.owner}中"
              account_pointer += 1
            else
              puts "帐号不足"
            end
          end
        end
      end
    end
    puts "cookie已导入完毕"
  end

  desc "load cookies from file"
  task :load_cookies_from_file,[:filename] => :environment do |t, args|
    filepath = "weibo-account/" + args[:filename]
    file = File.open(filepath)
    Cook.switch_connection_to(args[:filename])
    file.readlines.each_with_index do |account,index|
      # web cookie
      cookie = Cook.new
      cookie.username = account.split[1]
      cookie.passwd = account.split[2]
      cookie.owner = account.split[0]
      cookie.expired = true
      cookie.frequent = false
      cookie.remark = ""
      cookie.content = ""
      cookie.page_type = "web"
      cookie.save

      # mobile cookie
      cookie = Cook.new
      cookie.username = account.split[1]
      cookie.passwd = account.split[2]
      cookie.owner = account.split[0]
      cookie.expired = true
      cookie.frequent = false
      cookie.remark = ""
      cookie.content = ""
      cookie.page_type = "mobile"
      cookie.save
    end
    puts "cookie已导入完毕"
  end

  desc "load cookies from file"
  task :load_provinces => :environment do |t, args|
    json = File.read("file/provinces.json")
    provinces = JSON.parse(json)
    provinces["provinces"].each do |province|
      pv = Province.new
      pv.id = province["id"]
      pv.name = province["name"]
      pv.save

      citys = province["citys"]
      citys.each do |city|
        ct = City.new
        ct.city_id = city.keys.first.to_i
        ct.province_id = province["id"]
        ct.name = city.values.first
        ct.save
        puts "#{city.values.first} has been saved."
      end
      puts "============ #{province["name"]} has been saved ============"
    end
    puts "load provinces successuflly."
  end

#  desc "migrate userinfo_from_searchs and baseinfos to users order by uid"
#  task :migrate_to_users,[:start_uid,:limit] => :environment do |t, args|
  desc "migrate userinfo_from_searchs and baseinfos to users order by uid"
  task :migrate_to_users,[:limit] => :environment do |t, args|
   limitnum = args[:limit].to_i
   while(true) do
    max_user = User.order("uid desc").limit(1).first
    start_uid = max_user.nil?? 0 : max_user.uid
    uids_todo = UserinfoFromSearch.select("uid").where("uid > ?", start_uid).limit(limitnum).order("uid asc")
    if uids_todo.length == 0 then break end
    uids_todo.each_with_index do |uid_object,index|
      uid = uid_object.uid
      user = User.new({:uid=>uid})
      userinfo = UserinfoFromSearch.find_by_uid(uid)
      if userinfo.nil? then next end
      user.province = userinfo.province.to_i
      user.city = userinfo.city.to_i
      user.v = userinfo.user_authorize
      user.age = userinfo.user_age.to_i 
      user.gender = userinfo.user_gender
      user.has_contact = userinfo.has_contact
      user.has_name = userinfo.has_name
      baseinfo = Baseinfo.find_by_uid(uid)
      if !baseinfo.nil?
        user.screen_name = baseinfo.screen_name
        user.description = baseinfo.description
        user.followers_count = baseinfo.followers_count
        user.fans_count = baseinfo.fans_count
        user.weibo_count = baseinfo.weibo_count
        user.tags = baseinfo.remark.to_s.gsub('$',' ').strip
        user.email = baseinfo.email
        user.qq = baseinfo.qq
        user.msn = baseinfo.msn
        user.school = baseinfo.school.to_s.gsub('$',' ').gsub('·','$').strip
        user.job = baseinfo.job.to_s.gsub('$',' ').gsub('·','$').strip
        user.birthday = baseinfo.birthday
        user.certification = baseinfo.certification
        user.daren = baseinfo.daren
      else
        user.has_contact = false
        user.has_name = false
      end
      if user.save
        puts "#{uid} ok"
      else
        puts "#{uid} fail"
      end
    end
   end
  end

#  desc "migrate userinfo_from_searchs and baseinfos to users order by uid"
#  task :migrate_to_users,[:start_uid,:limit] => :environment do |t, args|
  desc "build index for users table"
  task :index => :environment do |t, args|
   limitnum = 250
   while(true) do
   #10.times do
    users = User.where("province=31 and has_contact=true and has_name=true and has_index is null").limit(limitnum)
    break if users.empty?
    begin
     Sunspot.index!(users)
     puts "#{users.last.uid} indexed"
     users.each do |u|
      u.has_index = true
      u.save
     end
    rescue Exception => details
     puts "error: #{details}"
     users.each do |u|
      u.has_index = false
      u.save
     end
    end
   end
  end


  desc "build index for users in local mysql instance"
  task :local_index,[:province,:start,:batch_size] => :environment do |t, args|
   batch_size = args[:batch_size].to_i
   options = {
    :batch_size => batch_size,
    :start => args[:start].to_i
   }
   User.switch_connection_to(args[:province].to_s)  
   User.find_in_batches(options) do |users|
    break if users.empty?
    start = Time.now
    Rails.logger.info("[#{Time.now}] Start Index #{users.last.uid}")
    begin
     Sunspot.index(users.select { |model| model.indexable? })
     Sunspot.commit
     #Sunspot.index!(users)
     puts "#{users.last.uid} indexd"
     elapsed = Time.now-start
     Rails.logger.info("[#{Time.now}] Completed Indexing. Rows/sec: #{batch_size/elapsed.to_f} (Elapsed: #{elapsed} sec.)")
    rescue Exception => details
     puts "error: #{details}"
    end
   end
  end

end

