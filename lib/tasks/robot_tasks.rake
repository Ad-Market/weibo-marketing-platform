# -*- coding: utf-8 -*-
require 'robot'
namespace :RobotTasks do

  desc "repost weibos for every small accounts"
  task :repost, [:browser_name] => :environment do |t, args|
    robot = Robot::Weibo::MobileRobot.new(args[:browser_name])
    begin
      BigAccount.all.each do |big_account|
        repost_interval = big_account.member.repost_interval
        random_repost_interval = Random.new.rand(((repost_interval>5)? repost_interval-5 : 3)..(repost_interval+5))
        weibos_to_repost = big_account.repost_sources.order("create_time desc").limit(100)
        if weibos_to_repost.empty?
          puts "#{Time.now}: 数据库中没有大号#{big_account.screen_name}的微博"
        else
          comments = big_account.member.repost_contents
          weibo_index = rand(weibos_to_repost.length)
          comment_index = rand(comments.length)

          big_account.small_accounts.where("(last_repost_time is null or last_repost_time < ?) and (status is null or status = ?)", random_repost_interval.minutes.ago, 1).order("updated_at asc").limit(1).each do |small_account|
            begin
              puts "last repost time: #{small_account.last_repost_time || "empty"}, and repost_interval is setted as #{random_repost_interval}"
              weibo_index = (weibo_index+1) % weibos_to_repost.length
              comment_index = (comment_index+1) % comments.length unless comments.empty?
              comment = comments.empty?? "" : comments[comment_index].content
              robot.logout
              robot.goto_login_page
              robot.login(small_account.username, small_account.password)

              if robot.is_failed_login?
                small_account.update_attributes({:status => -1})
                puts "帐号#{small_account.username}登录失败"
                next
              end

              if robot.is_blocked_page?
                small_account.update_attributes({:status => -1})
                puts "帐号#{small_account.username}被封"
                next
              end
              
              if robot.is_verification_page?
                small_account.update_attributes({:status => -1})
                puts "帐号#{small_account.username}需要验证码"
                next
              end
              if robot.is_frozen_page?
                small_account.update_attributes({:status => -1})
                puts "帐号#{small_account.username}被冻结"
                next
              end
              robot.goto_repost_page(weibos_to_repost[weibo_index].wid)
              if robot.is_weibo_unexist_page?
                RepostSource.delete(weibos_to_repost[weibo_index].wid)
                puts "weibo #{weibos_to_repost[weibo_index].wid} does not exist."
                next
              end
              robot.repost(comment)
              small_account.update_attributes({:last_repost_time => Time.now.utc})
              puts "weibo index:#{weibo_index}, 用户#{small_account.username} 转发了一条来自＠#{big_account.screen_name} 的微博，微博ID为#{weibos_to_repost[weibo_index].wid}"
              puts "微博内容为:#{weibos_to_repost[weibo_index].content}, 评论内容为: #{comment}, 转发时间: #{Time.now}"
            rescue Exception => ex
              puts "帐号#{small_account.username}登录时出现异常,已跳过本次登录"
            end
          end
        end
      end
    rescue Exception => details
      puts "Error in robot: #{details}"
    ensure
      # close the browser
      robot.destroy
    end
  end

end
