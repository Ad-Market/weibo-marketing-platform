# -*- coding: utf-8 -*-
class StatusController < ApplicationController
  layout "admin"
  before_filter :admin_authorize
  
  def index
  end
  
  def get_total_user_status_of_a_province
    User.switch_connection_to(params[:province])
    
    @all_user_count = CACHE.get("#{params[:province]}_all_user_count")
    if @all_user_count.nil?
      @all_user_count = User.count
      CACHE.set("#{params[:province]}_all_user_count", @all_user_count, 7.day)
    end

    @empty_mobile_count = CACHE.get("#{params[:province]}_empty_mobile_count")
    if @empty_mobile_count.nil?
      @empty_mobile_count = User.where("has_name is false or screen_name is null or screen_name=?","").count
      CACHE.set("#{params[:province]}_empty_mobile_count", @empty_mobile_count, 7.day)
    end
    
    @zero_contact_count = CACHE.get("#{params[:province]}_zero_contact_count")
    if @zero_contact_count.nil?  
      @zero_contact_count = User.where("(followers_count=? or followers_count is null) and (fans_count=? or fans_count is null) and (weibo_count=? or weibo_count is null)",0,0,0).count
      CACHE.set("#{params[:province]}_zero_contact_count", @zero_contact_count, 7.day)
    end

    @result = {
      :all_user_count => @all_user_count,
      :zero_contact_count => @zero_contact_count,
      :empty_mobile_count => @empty_mobile_count,
    }
    render json: @result 
  end

  def get_daily_user_status_of_a_province
    @new_user_of_today = User.where("created_at between ? and ?", Date.today.beginning_of_day, Date.today.end_of_day).count
    @new_user_of_yesterday = User.where("created_at between ? and ?", Date.yesterday.beginning_of_day, Date.yesterday.end_of_day).count
    @new_user_of_2_day_ago = User.where("created_at between ? and ?", 2.day.ago.beginning_of_day, 2.day.ago.end_of_day).count
    @new_user_of_3_day_ago = User.where("created_at between ? and ?", 3.day.ago.beginning_of_day, 3.day.ago.end_of_day).count
    @new_user_of_4_day_ago = User.where("created_at between ? and ?", 4.day.ago.beginning_of_day, 4.day.ago.end_of_day).count
    @new_user_of_5_day_ago = User.where("created_at between ? and ?", 5.day.ago.beginning_of_day, 5.day.ago.end_of_day).count
    @new_user_of_6_day_ago = User.where("created_at between ? and ?", 6.day.ago.beginning_of_day, 6.day.ago.end_of_day).count

    @result = {
      :new_user_of_today => @new_user_of_today,
      :new_user_of_yesterday => @new_user_of_yesterday,
      :new_user_of_2_day_ago => @new_user_of_2_day_ago,
      :new_user_of_3_day_ago => @new_user_of_3_day_ago,
      :new_user_of_4_day_ago => @new_user_of_4_day_ago,
      :new_user_of_5_day_ago => @new_user_of_5_day_ago,
      :new_user_of_6_day_ago => @new_user_of_6_day_ago
    }
    respond_to do |format|
      format.json { render json: @result }
    end
  end

  def get_web_cook_status_of_a_province
    @cook_count = Cook.where("page_type=? and frequent=? and owner like ?", "web", false, "%#{params[:province]}%").count
    @owner_count = Cook.where("page_type=? and frequent=? and owner like ?", "web", false, "%#{params[:province]}%").group("owner").length
    @valid_count = Cook.where("page_type=? and frequent=? and expired=? and owner like ?", "web", false, false, "%#{params[:province]}%").count
    @expired_count = Cook.where("page_type=? and frequent=? and expired=? and owner like ?", "web", false, true, "%#{params[:province]}%").count
    @cook_update_betweent_0_to_5_hour = Cook.where("page_type=? and frequent=? and expired=? and updated_at > ? and owner like ?", "web", false, false, 5.hour.ago, "%#{params[:province]}%").count
    @cook_update_betweent_5_to_10_hour = Cook.where("page_type=? and frequent=? and expired=? and (updated_at between ? and ?) and owner like ?", "web", false, false, 10.hour.ago, 5.hour.ago, "%#{params[:province]}%").count
    @cook_update_betweent_10_to_15_hour = Cook.where("page_type=? and frequent=? and expired=? and (updated_at between ? and ?) and owner like ?", "web", false, false, 15.hour.ago, 10.hour.ago, "%#{params[:province]}%").count
    @cook_update_betweent_15_to_20_hour = Cook.where("page_type=? and frequent=? and expired=? and (updated_at between ? and ?) and owner like ?", "web", false, false, 20.hour.ago, 15.hour.ago, "%#{params[:province]}%").count
    @cook_update_betweent_20_to_24_hour = Cook.where("page_type=? and frequent=? and expired=? and (updated_at between ? and ?) and owner like ?", "web", false, false, 24.hour.ago, 20.hour.ago, "%#{params[:province]}%").count
    @cook_update_before_24_hour = Cook.where("page_type=? and frequent=? and expired=? and updated_at < ? and owner like ?", "web", false, false, 24.hour.ago, "%#{params[:province]}%").count
    @cook_die_today = Cook.where("page_type=? and frequent=? and updated_at between ? and ? and owner like ?", "web", true, Date.today.beginning_of_day, Date.today.end_of_day, "%#{params[:province]}%").count
    @cook_die_yesterday = Cook.where("page_type=? and frequent=? and updated_at between ? and ? and owner like ?", "web", true, Date.yesterday.beginning_of_day, Date.yesterday.end_of_day, "%#{params[:province]}%").count
    @cook_die_2dayago = Cook.where("page_type=? and frequent=? and updated_at between ? and ? and owner like ?", "web", true, 2.day.ago.beginning_of_day, 2.day.ago.end_of_day, "%#{params[:province]}%").count
    @cook_die_3dayago = Cook.where("page_type=? and frequent=? and updated_at between ? and ? and owner like ?", "web", true, 3.day.ago.beginning_of_day, 3.day.ago.end_of_day, "%#{params[:province]}%").count
    @cook_die_4dayago = Cook.where("page_type=? and frequent=? and updated_at between ? and ? and owner like ?", "web", true, 4.day.ago.beginning_of_day, 4.day.ago.end_of_day, "%#{params[:province]}%").count
    @cook_die_5dayago = Cook.where("page_type=? and frequent=? and updated_at between ? and ? and owner like ?", "web", true, 5.day.ago.beginning_of_day, 5.day.ago.end_of_day, "%#{params[:province]}%").count
    @cook_die_6dayago = Cook.where("page_type=? and frequent=? and updated_at between ? and ? and owner like ?", "web", true, 6.day.ago.beginning_of_day, 6.day.ago.end_of_day, "%#{params[:province]}%").count

    @result = {
      :cook_count => @cook_count,
      :owner_count => @owner_count,
      :valid_count => @valid_count,
      :expired_count => @expired_count,
      :cook_update_betweent_0_to_5_hour => @cook_update_betweent_0_to_5_hour,
      :cook_update_betweent_5_to_10_hour => @cook_update_betweent_5_to_10_hour,
      :cook_update_betweent_10_to_15_hour => @cook_update_betweent_10_to_15_hour,
      :cook_update_betweent_15_to_20_hour => @cook_update_betweent_15_to_20_hour,
      :cook_update_betweent_20_to_24_hour => @cook_update_betweent_20_to_24_hour,
      :cook_update_before_24_hour => @cook_update_before_24_hour,
      :cook_die_today => @cook_die_today,
      :cook_die_yesterday => @cook_die_yesterday,
      :cook_die_2dayago => @cook_die_2dayago,
      :cook_die_3dayago => @cook_die_3dayago,
      :cook_die_4dayago => @cook_die_4dayago,
      :cook_die_5dayago => @cook_die_5dayago,
      :cook_die_6dayago => @cook_die_6dayago
    }
    respond_to do |format|
      format.json { render json: @result }
    end
  end

  def get_mobile_cook_status_of_a_province
    @cook_count = Cook.where("page_type=? and owner like ?", "mobile", "%#{params[:province]}%").count
    @owner_count = Cook.where("page_type=? and remark=? and owner like ?", "mobile", "update", "%#{params[:province]}%").group("owner").length
    @valid_count = Cook.where("page_type=? and remark=? and owner like ?", "mobile", "update", "%#{params[:province]}%").count
    @new_count = Cook.where("page_type=? and ((remark=? or remark is null) or (remark=? and content=?) or remark=? or remark=?) and owner like ?", "mobile", "", "update", "", "unknow",  "verify", "%#{params[:province]}%").count
    @forbidden_count = Cook.where("page_type=? and (frequent=? or remark=?) and owner like ?", "mobile", true, "forbidden", "%#{params[:province]}%").count

    @result = {
      :cook_count => @cook_count,
      :owner_count => @owner_count,
      :valid_count => @valid_count,
      :forbidden_count => @forbidden_count,
      :new_count => @new_count
    }
    respond_to do |format|
      format.json { render json: @result }
    end
  end

  def get_crawler_progress
    crawler_progress = {}
    machines = ["shanghai","zhejiang","jiangsu","guangdong"]
    crawler_types = ["mobile","contact","empty","zero","update"]
    indexes = (0..19)
    crawler_types.each do |type|
      machines.each do |machine|
        indexes.each do |index|
          key = "#{machine}_#{index}_#{type}_uid"
          crawler_progress[key] = CACHE.get(key)
        end
      end
    end
    render json: crawler_progress
  end

  def get_disk_status
    result = {
      :content => `diskcheck`
    }
    render json: result
  end

  def get_cpu_status
    result = {
      :content => `cpucheck`
    }
    render json: result
  end

  def get_rake_status
    @result = {
      :content => `monitor`
    }
    render json: @result
  end

  def get_timeline_crawler_status
    result = BigAccount.all.map{|big_account| {
      :uid => big_account.uid,
      :screen_name => big_account.screen_name,
      :weibo_count => big_account.repost_sources.count,
      :last_weibo_create_time => big_account.repost_sources.maximum("create_time").getlocal.strftime("%F %T")
    }}
    render json: result    
  end

  def get_repost_robot_status
    result = SmallAccount.all.map{|small_account| {
      :username => small_account.username,
      :status => small_account.status,
      :last_repost_time => small_account.last_repost_time.nil?? nil : small_account.last_repost_time.getlocal.strftime("%F %T")
    }}
    render json: result    
  end

end
