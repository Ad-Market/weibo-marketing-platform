class CompetitorController < ApplicationController
  
  before_filter :require_weibo_login

  #
  def index
  end


  # params = {:name => xxx}
  def rt_interactive_users_of_one_account
    screen_name = params[:name] || session[:screen_name]
    headers['Last-Modified'] = Time.now.httpdate
    render json: CACHE.get("interactive_users_#{screen_name}")
  end

end
