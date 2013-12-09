# -*- coding: utf-8 -*-
class LbsController < ApplicationController

  before_filter :require_weibo_login
  before_filter :require_advanced_rights, :only => [:export]

  def index
  end

  def export
     @name = params[:name]
     @name = @name.gsub(/\$\$/,"\n")
     send_data(@name, :filename => "export-lbs-#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.csv",:disposition => 'attachment')
  end
  
end
