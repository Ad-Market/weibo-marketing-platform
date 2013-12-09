# -*- coding: utf-8 -*-
require 'watir-webdriver'
namespace :Sina do
  desc "auto register emial"
  task :apply_mail => :environment do |t, args|

    # 注册mail
    b = Watir::Browser.new :firefox, :profile => 'default'
        file = File.open("export/mail_count"+".csv","a")
        tokensChar = ("a".."z").to_a
        tokens = ("a".."z").to_a  + ("0".."9").to_a
        username = ""
        usernametemp = ""
      while b.url != "https://login.sina.com.cn/signup/signup.php?entry=freemail"
        if username != ""
        file.puts "用户名: "+username+"@sina.cn"+"   密码: "+usernametemp
        end
      begin
        username = ""
        usernametemp = tokensChar[rand(tokensChar.size-1)]
        1.upto(9) { |i| usernametemp << tokens[rand(tokens.size-1)] }
        b.goto 'http://login.sina.com.cn/sso/logout.php?r=%2Fsignup%2Fsignup.php%3Fentry%3Dfreemail'
        b.goto 'https://login.sina.com.cn/signup/signup.php?entry=freemail'
        b.text_field(:name => 'user_name').set(usernametemp)
        b.text_field(:name => 'password').set(usernametemp)
        b.text_field(:name => 'password2').set(usernametemp)
        b.select_list(:name => 'selectQid').select '我手机号码的后6位？'
        b.text_field(:name => 'pwdA').set("111111")
#        b.text_field(:name => 'door').set("checknum")
#        b.button(:class => 'btn_submit_l').click
        sleep 5
        username = b.text_field(:name => 'user_name').value
        while b.url == "https://login.sina.com.cn/signup/signup.php?entry=freemail"
          sleep 5
          b.button(:class => 'btn_submit_l').click
        end
      rescue Exception => details
#    b.close
      end
     end
  end
end

namespace :Wangyi do
  desc "auto register email"
  task :apply_mail => :environment do |t, args|

    # 注册mail
    b = Watir::Browser.new :firefox, :profile => 'default'
        file = File.open("export/mail_count"+".csv","a")
        tokens = ("a".."z").to_a  + ("0".."9").to_a
        tokensChar = ("a".."z").to_a
        username = ""
        usernametemp = ""
        passwd = ""
    while true 
     while b.url!='http://reg.email.163.com/unireg/call.do?cmd=register.entrance&from=163&regPage=163'
        if username != ""
          file.puts "用户名: "+username+"@163.com"+"   密码: "+passwd
        end
      begin
        username = ""
        usernametemp = ""
        usernametemp = tokensChar[rand(tokensChar.size-1)]
        passwd = ""
        1.upto(9) { |i| usernametemp << tokens[rand(tokens.size-1)] }
        1.upto(6) { |i| passwd << tokens[rand(tokens.size-1)] }
#        b.goto 'http://login.sina.com.cn/sso/logout.php?r=%2Fsignup%2Fsignup.php%3Fentry%3Dfreemail'
        b.goto 'http://reg.email.163.com/mailregAll/reg0.jsp?from=163&regPage=163'
        b.text_field(:id => 'nameIpt').set(usernametemp)
        b.text_field(:id => 'mainPwdIpt').set(passwd)
        b.text_field(:id => 'mainCfmPwdIpt').set(passwd)
#        b.button(:class => 'btn_reg').click
        sleep 10
        username = b.text_field(:id => 'nameIpt').value
      rescue Exception => details
         puts details
      end
#        while b.url == "http://reg.email.163.com/mailregAll/reg0.jsp?from=163&regPage=163" || "http://reg.email.163.com/mailregAll/greylist2.do?username=uycevs1xel&domain=163.com&version=regvf1"
     end
   end  
 end
end

namespace :Sina do
  desc "auto register weibo"
  task :apply_weibo => :environment do |t, args|

    # 注册mail
    b = Watir::Browser.new :firefox, :profile => 'default'
        file1 = File.open("export/mail_count"+".csv","r")
        file2 = File.open("export/weibo_count"+".csv","a")
        username = ""
        passwd = ""
    while true
     while b.url!= 'http://weibo.com/signup/signup.php'
      if username != ""
          file2.puts "用户名: "+username+"@163.com"+"   密码: "+passwd
        end
      begin
        userInfoList = file1.readline.split " "
        username = userInfoList[1]
        passwd = userInfoList[3]
        b.goto 'http://weibo.com/signup/signup.php'
        s = b.select_list :id => 'province'
        s.select '上海'
        b.text_field(:id => 'reg_username').set(username)
        b.text_field(:id => 'reg_password').set(passwd)
        b.text_field(:id => 'nickname').set(passwd)
        b.text_field(:id => 'realname').set("窦放大")
        b.text_field(:id => 'sin').set("340711197702035994")
#        b.button(:class => 'btn_reg').click
        sleep 10
      rescue Exception => details
         puts details
      end
     end
   end
  end
end

namespace :Wangyi do
  desc "auto active weibo"
  task :active_weibo => :environment do |t, args|

    # 注册mail
    b = Watir::Browser.new :firefox, :profile => 'default'
        file = File.open("export/weibo_count"+".csv","r")
        username = ""
        passwd = ""
        file.readline
    while true
      mailurl = b.url.split("?").first
     while mailurl!='http://twebmail.mail.163.com/js5/main.jsp'
      begin
        userInfoList = file.readline.split " "
        username = userInfoList[1].split("@").first
        passwd = userInfoList[3]
        b.goto 'http://mail.163.com/'
        b.text_field(:id => 'idInput').set(username)
        b.text_field(:id => 'pwdInput').set(passwd)
        b.button(:id => 'loginBtn').click
        sleep 10
        mailurl = b.url.split("?").first
      rescue Exception => details
         puts details
      end
     end
   end
  end
end

namespace :Sohu do
  desc "auto register email"
  task :apply_mail => :environment do |t, args|

    # 注册mail
    b = Watir::Browser.new :firefox, :profile => 'default'
        file = File.open("export/mail_count"+".csv","a")
        tokens = ("a".."z").to_a  + ("0".."9").to_a
        tokensChar = ("a".."z").to_a
        username = ""
        usernametemp = ""
        passwd = ""
    while true
     while b.url!='http://passport.sohu.com/web/dispatchAction.action'
        if username != ""
          file.puts "用户名: "+username+"@sohu.com"+"   密码: "+passwd
        end
      begin
        username = ""
        usernametemp = ""
        usernametemp = tokensChar[rand(tokensChar.size-1)]
        passwd = ""
        1.upto(9) { |i| usernametemp << tokens[rand(tokens.size-1)] }
        1.upto(6) { |i| passwd << tokens[rand(tokens.size-1)] }
#        b.goto 'http://login.sina.com.cn/sso/logout.php?r=%2Fsignup%2Fsignup.php%3Fentry%3Dfreemail'
        b.goto 'http://passport.sohu.com/web/dispatchAction.action'
        b.text_field(:id => 'sohupp-email').set(usernametemp)
        b.text_field(:id => 'sohupp-password').set(passwd)
        b.text_field(:id => 'sohupp-confirmpwd').set(passwd)
#        b.button(:class => 'btn_reg').click
        sleep 10
        username = b.text_field(:id => 'sohupp-email').value
      rescue Exception => details
         puts details
      end
    end
   end
 end
end

