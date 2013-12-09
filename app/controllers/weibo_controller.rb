# -*- coding: utf-8 -*-
class WeiboController < ApplicationController

  before_filter :require_weibo_login

  def rate_limit
    render json: get_rate_limit
  end

  def get_uid_by_name
  	weibo_name = params[:name]
  	profile = {}
  	begin
			client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
			profile = client.users.show({:screen_name => weibo_name})
  	rescue OAuth2::Error => ex
  		puts "Error occoured when calling WeiboController:get_uid_by_name, Details: #{error_beautify(ex)}"
  	end	
	  render json: (profile.empty?? {} : {:avatar=>profile["profile_image_url"], :uid=>profile["id"]})
  end

  # params = {:name => xxx, :original => true|false(default)}
  def statuses
    screen_name = params[:name]
    status_filter = params[:original]? 1 : 0
    render json: get_statuses(screen_name, status_filter)
  end

  # params = {:mid => mid, :comment => true(default)|false, :repost => true(default)|false}
  def interactive_users_of_one_status
    mid = params[:mid]
    is_comment = params[:comment]=="false" ? false : true
    is_repost = params[:repost]=="false" ? false : true
    response_body = {}
    rate_limit = get_rate_limit
    if rate_limit[:remaining_ip_hits] < 10 || rate_limit[:remaining_user_hits] < 10
      response_body = {:status => -1, :description => "API request is expired."}
    else
      status_id = convert_mid_to_id(mid)
      count = get_repost_and_comment_count(status_id) 
      interactive_users = {}
      # get comments
      if count[:comments] > 0 && is_comment
        # TODO          
      end
      # get reposts
      if is_repost
        
      end
    end
    render json: response_body
  end

  # params = {:name => xxx, :original => true|false(default), :comment => true(default)|false, :repost => true(default)|false}
  def interactive_users_of_one_account
    screen_name = params[:name] || session[:screen_name]
    CACHE.set("interactive_users_#{screen_name}", {:percent => 0.0 ,:users => []}, 1.day)
    #logger.info "#{screen_name}"
    status_filter = params[:original]=="true" ? 1 : 0
    is_comment = params[:comment]=="false" ? false : true
    is_repost = params[:repost]=="false" ? false : true 
    statuses = get_statuses(screen_name, status_filter)
    interactive_users = {}
  
    unless !is_comment && !is_repost
     statuses.each_with_index do |status, index|
      rate_limit = get_rate_limit
      break if rate_limit[:remaining_ip_hits] < 10 || rate_limit[:remaining_user_hits] < 10
      logger.info "the #{index+1}th status"
      # interact by comment
      if status[:comments_count] > 0 && is_comment
        comments = get_comments(status[:id], status[:comments_count])
        comments.each do |comment|
         if comment[:user][:screen_name] != screen_name                # filter yourself
          if interactive_users[comment[:user][:screen_name]].nil?
            interactive_users.store(comment[:user][:screen_name],{
              :id => comment[:user][:id], 
              :screen_name => comment[:user][:screen_name],
              :location => comment[:user][:location],
              :gender => transform_gender(comment[:user][:gender]),
              :followers_count => comment[:user][:followers_count],
              :friends_count => comment[:user][:friends_count],
              :statuses_count => comment[:user][:statuses_count],
              :verified => comment[:user][:verified] ? "是" : "否",
              :description => comment[:user][:description],
              :histories => [{
                :type => "comment", 
                :text => comment[:text], 
                :source => get_source_text(comment[:source]), 
                :created_at => comment[:created_at]
              }]
            })
          else
            interactive_users[comment[:user][:screen_name]][:histories] << {
              :type => "comment", 
              :text => comment[:text], 
              :source => get_source_text(comment[:source]), 
              :created_at => comment[:created_at]
            }
          end
          CACHE.set("interactive_users_#{screen_name}", {:percent => (index+1)/statuses.length.to_f ,:users => interactive_users.values}, 1.day)
         end
        end
      end
      # interact by repost
      if status[:reposts_count] > 0 && is_repost
        reposts = get_reposts(status[:id], status[:reposts_count])
        reposts.each do |repost|
         if repost[:user][:screen_name] != screen_name
          if interactive_users[repost[:user][:screen_name]].nil?
            interactive_users.store(repost[:user][:screen_name], {
              :id => repost[:user][:id],
              :screen_name => repost[:user][:screen_name],
              :location => repost[:user][:location],
              :gender => transform_gender(repost[:user][:gender]),
              :followers_count => repost[:user][:followers_count],
              :friends_count => repost[:user][:friends_count],
              :statuses_count => repost[:user][:statuses_count],
              :verified => repost[:user][:verified] ? "是" : "否",
              :description => repost[:user][:description],
              :histories => [{
                :type => "repost", 
                :text => repost[:text], 
                :source => get_source_text(repost[:source]), 
                :created_at => repost[:created_at]
              }]
            })
          else
            interactive_users[repost[:user][:screen_name]][:histories] << {
              :type => "repost", 
              :text => repost[:text], 
              :source => get_source_text(repost[:source]), 
              :created_at => repost[:created_at]
            }
          end
          CACHE.set("interactive_users_#{screen_name}", {:percent => (index+1)/statuses.length.to_f ,:users => interactive_users.values}, 1.day)
         end
        end
      end
     end
    end
    CACHE.set("interactive_users_#{screen_name}", {:percent => 1.0 ,:users => interactive_users.values}, 7.day)
    render json: {:status => 1}
  end

  def ajax_get_friends
    friends = []
    begin
      client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
      (1..(session["friends_count"]/200.to_f).ceil).each do |cursor_index|
        friends += client.friendships.friends({:uid => session["uid"], :count => 200, :cursor => (cursor_index-1)*200})["users"]
      end
    rescue OAuth2::Error => ex
      puts "Error occoured when calling WeiboController:ajax_get_friends, Details: #{error_beautify(ex)}"
    end
    render json: friends
  end

  def ajax_get_followers
    followers = []
    begin
	    client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
      (1..(session["followers_count"]/200.to_f).ceil).each do |cursor_index|
        followers += client.friendships.followers({:uid => session["uid"], :count => 200, :cursor => (cursor_index-1)*200})["users"]
      end
    rescue OAuth2::Error => ex
      puts "Error occoured when calling WeiboController:get_followers, Details: #{error_beautify(ex)}"
    end
    render json: followers
  end

  def ajax_get_friends_latest_weibo
    weibos = []
    begin
	    client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
      weibos = client.statuses.friends_timeline({:count => 200, :page => 1})["statuses"]
    rescue OAuth2::Error => ex
      puts "Error occoured when calling WeiboController:ajax_get_friends_latest_weibo, Details: #{error_beautify(ex)}"
    end
    render json: weibos
  end

  def ajax_get_single_user_weibo
    uid = params[:uid] || session[:uid]
    first_weibos = []
    begin
	    client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
      first_weibos = client.statuses.user_timeline({:uid => uid, :count => 1})["statuses"]
    rescue OAuth2::Error => ex
      puts "Error occoured when calling WeiboController:ajax_get_single_user_weibo, Details: #{error_beautify(ex)}"
    end
    render json: first_weibos
  end

  def ajax_comment_weibo
    weibo_id = params[:weibo_id]
    comment_content = params[:commit_content]
    status = 1
    p session
    begin
      client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
      client.comments.create(comment_content, weibo_id)["user"]
    rescue OAuth2::Error => ex
      puts error_beautify(ex)
      status = -1
    rescue Exception => ex
      puts "Error occoured when calling WeiboController:ajax_comment_weibo, Details: #{error_beautify(ex)}"
      status = -1 
    end
    render json: {:status => status}
  end

  def ajax_repost_weibo
    status = 1
    weibo_id = params[:weibo_id]
    repost_content = params[:repost_content]
    p 'content:' + repost_content
    begin
      client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
      client.statuses.repost(weibo_id, {:status=>repost_content})["user"]
    rescue OAuth2::Error => ex
      puts "Error occoured when calling WeiboController:ajax_repost_weibo, Details: #{error_beautify(ex)}"
      status = -1
    rescue Exception => ex
      puts "#{ex}"
      status = -1      
    end
    render json: {:status => status}
  end

  def ajax_nearby_timeline
    lat = params[:lat]
    long = params[:lng]
    range = params[:range] || 500
    count = params[:count] || 50
    startTime = params[:start]
    endTime = params[:end]
    message = []
    begin
      client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
      message = client.place.nearby_timeline(lat.to_f,long.to_f,{:range=>range,:count=>count,:starttime=>startTime.to_i,:endtime=>endTime.to_i})
    rescue OAuth2::Error => ex
      puts "Error occoured when calling WeiboController:ajax_nearby_timeline, Details: #{error_beautify(ex)}"
    end
    render json: message
  end

  def ajax_nearby_users
    lat = params[:lat]
    long = params[:lng]
    range = 5000
    count = 50
    startTime = params[:start]
    endTime = params[:end]
    message = []
    begin
      client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
      message = client.place.nearby_users(lat.to_f,long.to_f,{:range=>range,:count=>count,:starttime=>startTime.to_i,:endtime=>endTime.to_i})                         
    rescue OAuth2::Error => ex
      puts "Error occoured when calling WeiboController:ajax_nearby_users, Details: #{error_beautify(ex)}"
    end
    render json: message
  end

  private
    def get_rate_limit
      rate_limit = nil
      begin
        client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
        rate_limit = client.account.rate_limit_status()
      rescue OAuth2::Error => ex
        puts "Error occoured when calling WeiboController:get_uid_by_name, Details: #{error_beautify(ex)}"
      end
      rate_limit                         
    end

    def convert_mid_to_id(mid)
      client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
      client.statuses.queryid({:mid => mid, :type => 1, :isBase62 => 1})[:id]
    end
     
    def get_statuses(screen_name, feature)
      statuses = []
      begin
        client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
        statuses_in_first_page = client.statuses.user_timeline({:screen_name => screen_name, :count => 100, :feature => feature})
        statuses += statuses_in_first_page[:statuses].map{|s| {:id=>s.id, :reposts_count=>s.reposts_count, :comments_count=>s.comments_count}}
        total_number = statuses_in_first_page[:total_number].to_i
        if total_number > 100
          (2..(total_number/100.to_f).ceil).each do |page|
            statuses += client.statuses.user_timeline({:screen_name => screen_name, :feature => feature, :count => 100, :page => page})[:statuses].map{|s| {:id=>s.id, :reposts_count=>s.reposts_count, :comments_count=>s.comments_count}}
          end
        end
      rescue OAuth2::Error => ex
        puts "Error occoured when calling WeiboController:get_statuses, Details: #{error_beautify(ex)}"
      end
      statuses                                                                         
    end

    def get_comments(status_id, comments_count)
      comments = []
      begin
        client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
        (1..(comments_count/200.to_f).ceil).each do |page|
          comments += client.comments.show(status_id, {:count => 200, :page => page})[:comments]
          logger.info "The #{page}th request for comments_authors for status(#{status_id})"
        end
      rescue OAuth2::Error => ex
        logger.error "Error occoured when calling WeiboController:get_comments, Details: #{error_beautify(ex)}"
      end
      comments
    end

    def get_reposts(status_id, reposts_count)
      reposts = []
      begin
        client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
        (1..(reposts_count/200.to_f).ceil).each do |page|
          reposts += client.statuses.repost_timeline(status_id, {:count => 200, :page => page})[:reposts]
          logger.info "The #{page}th request for reposts_authors for status(#{status_id})"
        end
      rescue OAuth2::Error => ex
        logger.error "Error occoured when calling WeiboController:get_reposts, Details: #{error_beautify(ex)}"
      end
      reposts
    end

    def get_repost_and_comment_count(status_id)
      client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
      client.statuses.count({:id => status_id}).first
    end

end
