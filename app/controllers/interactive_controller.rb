# -*- coding: utf-8 -*-
class InteractiveController < ApplicationController

  before_filter :require_weibo_login

  def index
  end

end
