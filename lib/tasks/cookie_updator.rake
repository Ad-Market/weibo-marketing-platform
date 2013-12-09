# -*- coding: utf-8 -*-
require 'watir-webdriver'
namespace :CookieUpdator do
  desc "Daily update all cookies"
  task :daily_update_web_cookies,[:province,:limit,:ago] => :environment do |t, args|
    puts "province:" + args[:province] + " time:" + Time.now.to_s
    #Cook.switch_connection_to(args[:province])
    expired_cookies = Cook.where("(updated_at < ? or expired = ?) and frequent = ? and page_type = ? and owner like ?", args[:ago].to_i.hour.ago, true, false, "web", "#{args[:province]}%").limit(args[:limit].to_i)
    #expired_cookies = Cook.where("page_type = ? and owner like ?", "web", "#{args[:province]}%").limit(args[:limit].to_i)
    if expired_cookies.empty?
      puts "不存在已过期的cookie,它们都跑得很欢乐,oh yeah!!!"
      exit
    end
    count = expired_cookies.count
    puts "需要更新的cookie数量为：#{count}"
    # 更新cookie
    successful = true
    success_count = 0
    error_count = 0

  begin
    #b = Watir::Browser.new :firefox, :profile => 'default'
    b = Watir::Browser.new(:chrome)
    expired_cookies.each_with_index do |cook,index|
      begin
        b.goto 'www.weibo.com/logout.php?backurl=/login.php'
        b.goto 'www.weibo.com/login.php'
        sleep 1
        b.text_field(:name => 'loginname').set(cook.username)
        sleep 1
        b.text_field(:name => 'password').set(cook.passwd)
        sleep 1
        b.link(:class => 'W_btn_d').click
        sleep 5
        b.wait(10)
        puts b.url
        if b.url.include?("nguide/interest")
          # 高危帐号
          cook.expired = true
          cook.frequent = true
          cook.remark = ("freezon at " + Time.now.to_s)
          cook.save
          error_count += 1
          puts "(#{index+1} of #{count})用户" + cook.username + "的帐号存在高危风险，需要验证安全信息,密码："+cook.passwd
        elsif b.url.include?("unfreeze") || b.url.include?("userblock")
          # 异常帐号
          cook.expired = true
          cook.frequent = true
          cook.remark = ("freezon at " + Time.now.to_s)
          cook.save
          error_count += 1
          puts "(#{index+1} of #{count})用户" + cook.username + "的帐号异常,密码："+cook.passwd
        elsif b.url.include?("register") || b.url.include?("signup") || b.title.include?("推荐") || b.title.include?("我的") || b.title.include?("指南")
          # get cookie
          cookie_array = b.driver.manage.all_cookies
          cookie_items = []
          cookie_array.each do |h|
            cookie_items << (h[:name] +'='+ h[:value])
          end
          # save
          cook.content = cookie_items.join(';')
          cook.expired = false
          cook.frequent = false
          cook.remark = ("update at " + Time.now.to_s)
          cook.save
          puts "(#{index+1} of #{count})用户" + cook.username + "的cookie已更新成功"
          success_count += 1
        elsif b.url.include? "login.php"
          begin
            error_box = b.div :class => 'error_text'
            if error_box.exists? && (error_box.text.include?("错误") || error_box.text.include?("异常"))
              cook.expired = true
              cook.frequent = true
              cook.remark = "wrong"
              cook.save
              error_count += 1
              puts "(#{index+1} of #{count})用户" + cook.username + "的帐户错误或者被禁，密码："+cook.passwd
            elsif error_box.exists? && error_box.text.include?("验证码")
              puts "(#{index+1} of #{count})擦。。。本用户被封，需要输入验证码，用户" + cook.username + ",密码："+cook.passwd
            else
              puts "(#{index+1} of #{count})用户" + cook.username + "的cookie登录失败，需要重新登录，密码："+cook.passwd
            end
          rescue Exception => detail
            puts "(#{index+1} of #{count})用户" + cook.username + "的cookie登录失败，需要重新登录，密码："+cook.passwd
            next
          end
        else
          puts "(#{index+1} of #{count})用户" + cook.username + "的cookie登录失败，原因未知，需要重新登录，密码："+cook.passwd
        end
      rescue Timeout::Error => details
        puts "(#{index+1} of #{count})用户" + cook.username + "的cookie已更新失败, 原因：" + details.to_s
        successful = false
        begin
          puts "Timeout Error,尝试强制退出微博"
          b.reset!
        rescue Exception => details
          puts "强制退出微博失败"
        end
      rescue Exception => details
        puts "(#{index+1} of #{count})用户" + cook.username + "的cookie已更新失败, 原因：" + details.to_s
        successful = false
      end
    end
  rescue Exception => details
    put "未知异常，强制关闭浏览器"
  ensure
    b.close
  end

    if successful
      puts "所有cookie更新成功"
    else
      puts "结束cookie更新,#{count}个cookie中共有#{success_count}个更新成功,共有#{error_count}个作废"
    end
  end


  desc "update mobile cookies"
  task :pop_mobile_cookies,[:province] => :environment do |t, args|
    puts "province:" + args[:province] + " time:" + Time.now.to_s
    expired_cookies = Cook.where("expired = ? and frequent = ? and page_type = ? and owner like ? and remark = ?", false, false, "mobile", "%#{args[:province]}%", "update")
    #expired_cookies = Cook.where("remark != ? and frequent = ? and page_type = ?", "forbidden", false, "mobile")    
    if expired_cookies.empty?
      puts "不存在已过期的cookie,它们都跑得很欢乐,oh yeah!!!"
      exit
    end
    count = expired_cookies.count
    puts "需要更新的cookie数量为：#{count}"
    # 更新cookie
    successful = true
    success_count = 0
    error_count = 0
    b = Watir::Browser.new :chrome
    expired_cookies.each_with_index do |cook,index|
      begin
        sleep(2)
        b.goto '3g.sina.com.cn/prog/wapsite/sso/loginout.php?backURL=http%3A%2F%2Fweibo.cn%2Fpub%2F%3Fvt%3D&backTitle=%D0%C2%C0%CB%CE%A2%B2%A9&vt='
        sleep(5)
        b.goto '3g.sina.com.cn/prog/wapsite/sso/login.php?ns=1&revalid=2&backURL=http%3A%2F%2Fweibo.cn%2F&backTitle=%D0%C2%C0%CB%CE%A2%B2%A9&vt='
        sleep 1
        b.text_field(:name => 'mobile').set(cook.username)
        sleep 1
        b.text_field(:type => 'password').set(cook.passwd)
        sleep 1
        b.button(:name => 'submit').click
        cookie_array = b.driver.manage.all_cookies
        sleep 8
        b.wait(10)
        puts b.url
        if b.url.include?("unfreeze") || b.url.include?("userblock") || b.url.include?("freeze")
          # 异常帐号
          cook.expired = true
          cook.frequent = true
          cook.remark = ("freeze" + Time.now.to_s)
          cook.save
          error_count += 1
          puts "(#{index+1} of #{count})用户" + cook.username + "的帐号异常,密码："+cook.passwd
        elsif b.url.include?("weibo.cn/?gsid=") || b.url.include?("weibo.cn/pub") 
          # get cookie
          cookie_items = []
          cookie_array.each do |h|
            cookie_items << (h[:name] +'='+ h[:value])
          end
          # save
          puts "cookie: " + cookie_items.join(';')
          cook.content = cookie_items.join(';')
          cook.expired = false
          cook.frequent = false
          cook.remark = "update"
          cook.save
          puts "(#{index+1} of #{count})用户" + cook.username + "的cookie已更新成功"
          success_count += 1
        elsif b.url.include? "login_submit.php"
          begin
            error_box = b.div :class => 'msgErr'
            if error_box.exists? && (error_box.text.include?("错误") || error_box.text.include?("异常"))
              cook.expired = true
              cook.frequent = true
              cook.remark = "forbidden"
              cook.save
              error_count += 1
              puts "(#{index+1} of #{count})用户" + cook.username + "的帐户错误或者被禁，密码："+cook.passwd
            elsif error_box.exists? && error_box.text.include?("验证码")
              cook.expired = true
              cook.frequent = false
              cook.remark = "verify"
              cook.save
              puts "(#{index+1} of #{count})擦。。。本用户被封，需要输入验证码，用户" + cook.username + ",密码："+cook.passwd
            else
              cook.expired = true
              cook.frequent = false
              cook.remark = "unknow"
              cook.save
              puts "(#{index+1} of #{count})用户" + cook.username + "的cookie登录失败，需要重新登录，密码："+cook.passwd
            end
          rescue Exception => detail
            puts "(#{index+1} of #{count})用户" + cook.username + "的cookie登录失败，需要重新登录，密码："+cook.passwd
            next
          end
        else
          cook.expired = true
          cook.frequent = false
          cook.remark = "unknow"
          cook.save
          puts "(#{index+1} of #{count})用户" + cook.username + "的cookie登录失败，原因未知，需要重新登录，密码："+cook.passwd
        end
      rescue Timeout::Error => details
        puts "(#{index+1} of #{count})用户" + cook.username + "的cookie已更新失败, 原因：" + details.to_s
        successful = false
        begin
          puts "Timeout Error,尝试强制退出微博"
          b.reset!
        rescue Exception => details
          puts "强制退出微博失败"
        end
      rescue Exception => details
        puts "(#{index+1} of #{count})用户" + cook.username + "的cookie已更新失败, 原因：" + details.to_s
        successful = false
      end
    end
    b.close

    if successful
      puts "所有cookie更新成功"
    else
      puts "结束cookie更新,#{count}个cookie中共有#{success_count}个更新成功,共有#{error_count}个作废"
    end
  end



  ##### Deprecated task ######
  desc "update all cookies"
  task :update_web_cookies,[:owner] => :environment do |t, args|
    if args[:owner].nil?
      # （流畅模式：默认）更新所有组的cookie的同时不导致rake任务的中断
      expired_cookies = Cook.where("frequent = ? and page_type = ?", false, "web")
    elsif args[:owner.to_s] == "expired"
      # （补齐模式）更新所有组的已过期cookie
      expired_cookies = Cook.where("expired = ? and frequent = ? and page_type = ?", true, false, "web")
    elsif args[:owner].to_s == "syn"
      # （同步模式）强制重置cookie
      expired_cookies = Cook.where("frequent = ? and page_type = ?", false, "web")
      expired_cookies.each do |cook|
        cook.content = ""
        cook.expired = true
        cook.frequent = false
        cook.save
      end
      expired_cookies = Cook.where("expired = ? and frequent = ? and page_type = ?", true, false, "web")
    else
      # （组模式）只更新一组cookie
      expired_cookies = Cook.where("owner = ? and expired = ? and frequent = ? and page_type = ?", args[:owner], true, false, "web")
    end

    if expired_cookies.empty?
      puts "不存在已过期的cookie,它们都跑得很欢乐,oh yeah!!!"
      exit
    end
    puts "过期cookie已重置，需要更新的cookie数量为：" + expired_cookies.count.to_s

    # 更新cookie
    successful = true
    b = Watir::Browser.new :firefox, :profile => 'default'

    expired_cookies.each do |cook|
      begin
        b.goto 'www.weibo.com'
        b.text_field(:name => 'loginname').set(cook.username)
        b.text_field(:name => 'password').set(cook.passwd)
        b.link(:class => 'W_btn_d').click

        sleep 5

        # get cookie
        cookie_array = b.driver.manage.all_cookies
        cookie_items = []
        cookie_array.each do |h|
          cookie_items << (h[:name] +'='+ h[:value])
        end

        b.goto 'www.weibo.com/logout.php?backurl=/'

        # update cookie
        cook.content = cookie_items.join(';')
        cook.expired = false
        cook.frequent = false
        cook.remark = ("update at " + Time.now.to_s)
        cook.save
        puts "用户" + cook.username + "的cookie已更新成功"
      rescue Exception => details
        # mark it for expired mode
        cook.expired = true
        cook.frequent = false
        cook.remark = ("failed to update at " + Time.now.to_s)
        cook.save
        puts "用户" + cook.username + "的cookie已更新失败, 原因：" + details.to_s
        b.goto 'www.weibo.com/logout.php?backurl=/'
        successful = false
      end
    end
    b.close

    if successful
      puts "所有cookie更新成功"
    else
      puts "结束cookie更新,但部分cookie更新失败，请检查"
    end
  end
end
