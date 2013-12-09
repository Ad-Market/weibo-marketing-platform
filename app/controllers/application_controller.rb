# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
    def admin_authorize
      unless session[:admin_id] && Member.find(session[:admin_id]) && Member.find(session[:admin_id]).role == "admin"
        flash[:notice] = "请登录后台系统"
        redirect_to "/admin/login?back_uri=#{request.protocol}#{request.host_with_port}#{request.fullpath}"
      end
    end

    def require_weibo_login
      unless is_authed?
        session[:back_uri] = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
        redirect_to "/login"
      end
    end

    # TODO
    def require_advanced_rights
      puts "in require advanced rights"
      #p params
      #appname = get_appname_from_uri
      redirect_to "/service/advanced" unless is_advanced_member?(params[:controller], params[:action])
    end

    # def get_appname_from_uri
    #   puts "#{request.original_url}"
    # end

    def is_advanced_member?(controller, action)
      if is_authed?
        member = Member.find_by_uid(session[:uid])
        if controller == "search"
          advanced_action_list_in_search = ["export", "generate_csv", "statistics", "export_statistics"]
          return member.export_permission || false if advanced_action_list_in_search.include?(action)
        elsif controller == "follow"
          # no advanced rights
        elsif controller == "interactive"
          # no advanced rights
        elsif controller == "lbs"
          advanced_action_list_in_lbs = ["export"]
          return member.lbs_permission || false if advanced_action_list_in_lbs.include?(action)          
        elsif controller == "repost"
          advanced_action_list_in_repost = ["setting"]
          return member.repost_permission || false if advanced_action_list_in_repost.include?(action)                    
        elsif controller == "interactive"
          # no advanced rights
        elsif controller == "push"
          advanced_action_list_in_push = ["download"]
          return member.ads_permission || false if advanced_action_list_in_push.include?(action)                    
        end
      end
      return false
    end

    def is_authed?
      return false if session["logged"].nil?
      client = WeiboOAuth2::Client.from_hash({"token"=>session["token"], "expires_at"=>session["expires_at"]})
      return client.authorized?
    end

    def error_beautify(ex)
      code = ex.to_s.match(/:[0-9]+,/).to_s.match(/[0-9]+/).to_s
      error_description = Code::WEIBO_ERROR_INFO[code]
      error_description.nil?? "未知错误(错误代码：#{code})" : "#{error_description}"
    end

    #{"m"=>"男", "f"=>"女", "n"=>"未知"}
    def transform_gender(gender_code)
      transform_gender_hash = {"m"=>"男", "f"=>"女", "n"=>"未知"}
      transform_gender_hash[gender_code]
    end

    def get_source_text(source_html)
      source_html.match(/>.*</).to_s[1..-2]
    end
end
