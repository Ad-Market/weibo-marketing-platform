class DashboardController < ApplicationController

  def index
  	unless params[:code].nil?
	    authcode = params[:code]
	    begin
        p "in index"
	      client = WeiboOAuth2::Client.from_code(authcode)
	      uid = client.account.get_uid["uid"]
	      profile = client.users.show({:uid => uid})
	      p profile

	      member = Member.find_by_uid(uid)
	      if member.nil?
	        member = Member.create!({
	        	:uid=>uid, :weibo_name=>profile["screen_name"], 
	        	:role=>"user", :token=>client.access_token.token,
	        	:expires_at=>Time.now.utc,
	        	:avatar => profile["profile_image_url"]
	        })
	      else
          # todo expires_at
	      	member.update_attributes({
            :weibo_name=>profile["screen_name"],
            :token=>client.access_token.token,
            :expires_at=>Time.now.utc,
            :avatar => profile["profile_image_url"]
          })
	      end
	      p member

	      session["logged"] = true
	      session["id"] = member.id
	      session["uid"] = member.uid
        session["screen_name"] = profile["screen_name"]
	      session["token"] = client.access_token.token
	      session["expires_at"] = client.access_token.expires_at
        session["weibos_count"] = profile["statuses_count"]
        session["friends_count"] = profile["friends_count"]
        session["followers_count"] = profile["followers_count"]
	      p session
	    rescue OAuth2::Error => ex
	      @notice = error_beautify(ex.error_code)
        p @notice
	    rescue => ex
	      @notice = "unknow exception: #{ex.message}"
        p @notice
	    end
      redirect_to session[:back_uri] || "/"
  	end
  end

  def get_count_of_all_users
    search = User.search do
      fulltext ""
      paginate :page=>1, :per_page=>0
    end
    @result = {
      :all_user_count => search.total
    }
    respond_to do |format|
      format.json { render json: @result }
    end
  end

  def login
  end

  def auth
    client = WeiboOAuth2::Client.new
    authurl = client.auth_code.authorize_url
    redirect_to authurl
  end

  def logout
    reset_session
    begin
      WeiboOAuth2::Client.from_hash({"access_token"=>session["token"], "expires_at"=>session["expires_at"]}).account.logout
    rescue OAuth2::Error => ex
      puts "Error occoured when calling DashboardController:logout, Deatails: #{error_beautify(ex.error_code)}"
    rescue => ex
      puts "unknown exception: #{ex.message}"
    end
    redirect_to "/"
  end

  def cancel
  end

end
