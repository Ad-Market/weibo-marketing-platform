# -*- coding: utf-8 -*-
namespace :Exportor do
  desc "export users of a province sperated by city"
  task :export_users_of_a_province, [:province_pinyin,:start_time]  => :environment do |t, args|
    province_pinyin = args[:province_pinyin]
    start_time = args[:start_time].to_s.split('=').join(' ')
    puts "Export data updated from " + start_time.to_s
    province_code_hash = {
      "shanghai" => 31,
      "beijing" => 11,
      "zhejiang" => 33,
      "jiangsu" => 32,
      "guangdong" => 44,
      "chongqing" => 50,
      "fujian" => 35,
      "hunan" => 43,
      "shandong" => 37,
      "tianjin" => 12
    }
    
    province_code = province_code_hash[province_pinyin]
    province = Province.find(province_code)
    province_name = province.name
    puts 'Export data updated to: ' + UserinfoFromSearch.select("updated_at").where("province=? and has_name=? and has_contact=? and updated_at>?", province_code, true, true, start_time).order("updated_at desc").limit(1).first.updated_at.to_s
    province.cities.each do |city|
    #[15,16,17,18,19,20,30,1000].each do |city_code|
    #[4,5,6,7,8,9,10,12,13,14,15,16,17,18,19,20,30,1000].each do |city_code|
      city_code = city.city_id
      city_name = city.name
      count = 0
      puts "开始导出city为#{city_name}区"
      file = File.open("export/weibo_users_#{province_name}_#{city_name}_#{Date.today.to_s}.csv","w")
      file.puts "ID,昵称,省市,区县,年龄,性别,是否加v,签名,标签,兴趣爱好,认证信息,粉丝数,关注数,微博数,Email,QQ,MSN,公司信息,教育信息"
      uid_objects = UserinfoFromSearch.select("uid").where("province=? and city=? and has_name=? and has_contact=? and updated_at>?", province_code, city_code, true, true, start_time)
      uid_objects.each do |uid_obj|
        uid = uid_obj.uid
        user = UserinfoFromSearch.find_by_uid(uid)
        next if user.nil?
        baseinfo = user.baseinfo
        next if baseinfo.nil?
        screen_name = baseinfo.screen_name
        next if screen_name.nil?

        if user.user_gender == "man"
          gender = "男"
        elsif user.user_gender == "woman"
          gender = "女"
        else
          gender = "未知"
        end

        auth = user.user_authorize == "vip"? "是" : "否"

        if user.user_age == "18"
          age = "18岁以下"
        elsif user.user_age == "22"
          age = "19-22岁"
        elsif user.user_age == "29"
          age = "23-29岁"
        elsif user.user_age == "39"
          age = "30-39岁"
        elsif user.user_age == "40"
          age = "40岁以上"
        else user.user_age == ""
          age = "未知"
        end

        fans_count = baseinfo.fans_count.nil?? "" : baseinfo.fans_count.to_s
        followers_count = baseinfo.followers_count.nil?? "" : baseinfo.followers_count.to_s
        weibo_count = baseinfo.weibo_count.nil?? "" : baseinfo.weibo_count.to_s

        email = baseinfo.email.nil?? "" : baseinfo.email
        qq = baseinfo.qq.nil?? "" : baseinfo.qq
        msn = baseinfo.msn.nil?? "" : baseinfo.msn

        school = baseinfo.school
        job = baseinfo.job
    
        description = baseinfo.description
        remark = baseinfo.remark
        daren = baseinfo.daren
        certification = baseinfo.certification      
     
        schools = baseinfo.school.nil?? "" : baseinfo.school.gsub('$','')
        jobs = baseinfo.job.nil?? "" : baseinfo.job.gsub('$','')

        file.puts uid.to_s + "," +
          screen_name + "," +
          province_name + "," +
          city_name + "," +
          age + "," +
          gender + "," +
          auth + "," +
          description + "," +
          remark + "," +
          daren + "," +
          certification + "," +
          fans_count + "," +
          followers_count + "," +
          weibo_count + "," +
          email + "," +
          qq + "," +
          msn + "," +
          jobs + "," +
          schools
      
        count += 1
        print '.' if(count%10000==0)
      end
      file.close
      puts '结束一个区的导出,共计'+count.to_s+'个用户'
    end
  end

  desc "export_users_of_some_districts_of_shanghai"
  task :export_users_of_some_districts_of_shanghai, [:keywords]  => :environment do |t, args|
    keywords = args[:keywords]
    keywords_array = keywords.split('-')
    city_code_array = ['5','7','4','1','3','12','6','8','9','10','1000']
    province_code = '31'
    province_name = "上海"
    
    puts 'start to export data...'
    
    keywords_array.each do |keyword|
      count = 0
      puts "开始导出关键字#{keyword}的数据..."
      file = File.open("export/weibo_users_#{keyword}_#{Date.today.to_s}.csv","w")
      file.puts "ID,昵称,省市,区县,年龄,性别,是否加v,签名,标签,兴趣爱好,认证信息,粉丝数,关注数,微博数,Email,QQ,MSN,公司信息,教育信息"
      uid_objects = Baseinfo.select("uid").where("remark like ?", "%#{keyword}%")
      uid_objects.each do |uid_obj|
        uid = uid_obj.uid
        user = UserinfoFromSearch.find_by_uid(uid)
        next if user.nil? || user.province!=province_code || !city_code_array.include?(user.city)
        baseinfo = user.baseinfo
        next if baseinfo.nil?
        screen_name = baseinfo.screen_name
        next if screen_name.nil?

        if user.user_gender == "man"
          gender = "男"
        elsif user.user_gender == "woman"
          gender = "女"
        else
          gender = "未知"
        end

        auth = user.user_authorize == "vip"? "是" : "否"

        if user.user_age == "18"
          age = "18岁以下"
        elsif user.user_age == "22"
          age = "19-22岁"
        elsif user.user_age == "29"
          age = "23-29岁"
        elsif user.user_age == "39"
          age = "30-39岁"
        elsif user.user_age == "40"
          age = "40岁以上"
        else user.user_age == ""
         age = "未知"
        end

        if user.city != '1000'
          city_name = City.where("province_id=? and city_id=?", province_code.to_i, user.city.to_i).first.name
        else
          city_name = '未标识区'
        end

        fans_count = baseinfo.fans_count.nil?? "" : baseinfo.fans_count.to_s
        followers_count = baseinfo.followers_count.nil?? "" : baseinfo.followers_count.to_s
        weibo_count = baseinfo.weibo_count.nil?? "" : baseinfo.weibo_count.to_s

        email = baseinfo.email.nil?? "" : baseinfo.email
        qq = baseinfo.qq.nil?? "" : baseinfo.qq
        msn = baseinfo.msn.nil?? "" : baseinfo.msn

        school = baseinfo.school
        job = baseinfo.job

        description = baseinfo.description
        remark = baseinfo.remark
        daren = baseinfo.daren
        certification = baseinfo.certification

        schools = baseinfo.school.nil?? "" : baseinfo.school.gsub('$','')
        jobs = baseinfo.job.nil?? "" : baseinfo.job.gsub('$','')

        file.puts uid.to_s + "," +
          screen_name + "," +
          province_name + "," +
          city_name + "," +
          age + "," +
          gender + "," +
          auth + "," +
          description + "," +
          remark + "," +
          daren + "," +
          certification + "," +
          fans_count + "," +
          followers_count + "," +
          weibo_count + "," +
          email + "," +
          qq + "," +
          msn + "," +
          jobs + "," +
          schools

        count += 1
        print '.' if(count%100==0)
      end
      file.close
      puts "完成关键字#{keyword}的导出"
    end
  end 
end

