# -*- coding: utf-8 -*-
class PushController < ApplicationController

  before_filter :require_weibo_login
  before_filter :require_advanced_rights, :only => [:download]

  def index
  end

  def download
  end

end
