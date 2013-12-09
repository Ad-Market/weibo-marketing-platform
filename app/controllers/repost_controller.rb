class RepostController < ApplicationController

  before_filter :require_weibo_login
  before_filter :require_advanced_rights, :only => [:setting]

  def setting
    p session
    #member = (session.nil? || session[:member_id].nil?)? Member.find(4) : Member.find(session[:member_id])
    member = Member.find_by_uid(session[:uid])
    if request.get?
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: {
          :repost_interval => member.repost_interval,
          :comments => member.repost_contents.map{|rc| {
            :id => rc.id, 
            :comment => rc.content
          }},
          :big_accounts => member.big_accounts.map{|ba| {
            :uid => ba.uid,
            :screen_name => ba.screen_name,
            :small_accounts => ba.small_accounts.map{|sa| {
              :id => sa.id,
              :username => sa.username,
              :password => sa.password,
              :status => sa.status
            }}
          }}
        }}
      end
    elsif request.post?
      puts "catch a post request"
      member.repost_interval = params["repost_interval"]
      # save comments
      repost_contents = []
      params["comments"].each do |comment_hash|
        comment = nil
        if comment_hash["id"].nil?
          comment = RepostContent.new({:content => comment_hash["comment"]})  
        else
          comment = RepostContent.find(comment_hash["id"])
          comment.content = comment_hash["comment"]
          comment.save
        end 
        repost_contents << comment
      end
      member.repost_contents = repost_contents

      # save big accounts
      big_accounts = []
      params["big_accounts"].each do |big_account_json|
        big_account = BigAccount.find_by_uid(big_account_json["uid"])
        if big_account.nil?
          big_account = BigAccount.new({:uid => big_account_json["uid"], :screen_name => big_account_json["screen_name"]})
        else
          big_account.uid = big_account_json["uid"]
          big_account.screen_name = big_account_json["screen_name"]
          big_account.save
        end
        big_accounts << big_account
      end
      member.big_accounts = big_accounts
      member.save

      # delete comments
      RepostContent.where("member_id is null").each do |deleted_item|
        deleted_item.destroy
      end
      # delete big accounts
      BigAccount.where("member_id is null").each do |deleted_item|
        deleted_item.destroy
      end

      # save small accounts
      params["big_accounts"].each do |big_account_json|
        big_account = BigAccount.find_by_uid(big_account_json["uid"])
        small_accounts = []
        big_account_json["small_accounts"].each do |small_account_json|
          small_account = nil
          if small_account_json["id"].nil?
            small_account = SmallAccount.new(small_account_json)
          else
            small_account = SmallAccount.find(small_account_json["id"])
            small_account.username = small_account_json["username"]
            small_account.password = small_account_json["password"]
            small_account.save
          end
          small_accounts << small_account
        end
        big_account.small_accounts = small_accounts
        big_account.save
      end

      # delete small accounts
      SmallAccount.where("big_account_id is null").each do |deleted_item|
        deleted_item.destroy
      end

      render json: {:status => 1}
      #redirect_to "/repost/setting"
    end
  end
end
