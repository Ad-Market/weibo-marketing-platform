# -*- coding: utf-8 -*-
class FollowController < ApplicationController

  before_filter :require_weibo_login

  def index
  end

  def follow
    if !session.nil? && !session[:uid].nil?
      @is_authed = true
    end
    puts "params:" + params[:uids_to_follow]
    names = params[:uids_to_follow].split
    # statistics
    current_friend = ""
    success_count = 0
    statistics = {
      :count => names.count,
      :successful_count => 0,
      :fail_count => 0,
      :error_list => {}
    }
    begin
      @tab_id = "follow"
      client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
      names.each do |name|
        unless name.empty?
          current_friend = name
          begin
            client.friendships.create({:screen_name => name})
            statistics[:successful_count] += 1
          rescue OAuth2::Error => ex
            error_desc = error_beautify(ex)
            if statistics[:error_list][error_desc].nil?
              statistics[:error_list][error_desc] = 1
            else
              statistics[:error_list][error_desc] += 1
            end
            statistics[:fail_count] += 1
          end
        end
      end
      puts "error list: #{statistics}"
      error_notice = "。其中"
      statistics[:error_list].keys.each do |key|
        error_notice += ",#{statistics[:error_list][key]}人失败的原因为：#{key}"
      end
      @notice = "关注完毕，共计#{statistics[:count]}个用户，成功关注#{statistics[:successful_count]}个用户，失败#{statistics[:fail_count]}个用户"
      @notice += error_notice if statistics[:fail_count]>0
    rescue OAuth2::Error => ex
      @notice = error_beautify(ex)
    rescue Exception => ex
      @notice = "未知异常: #{ex.message}，请联系开发人员"
    end
    render "index"
  end

  def unfollow
    @tab_id = "unfollow"
    puts 'i am in unfollow'
    if !session.nil? && !session[:uid].nil?
      member = Member.find_by_uid(session[:uid])
      @uid = session["uid"]
      @img_url = member.avatar
      @screen_name = member.weibo_name
      @is_authed = true
    end
    current_friend = ""
    success_count = 0
    begin
      client = WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]})
      uids = params[:uids_to_unfollow].split(',')
      uids.each do |uid|
        current_friend = uid
        client.friendships.destroy({:uid => uid.to_i})
        success_count += 1
      end
      @notice = "批量消除关注成功"
    rescue OAuth2::Error => ex
      @notice = error_beautify(ex) + "，已成功取消关注#{success_count}个用户，在取消关注用户#{current_friend}的时候失败"
    rescue => ex
      @notice = "未知异常: #{ex.message}，请联系开发人员"
    end
    render "index"
  end

end
