# -*- coding: utf-8 -*-
class MembersController < ApplicationController
  layout "admin"
  before_filter :admin_authorize, :except => :login
  # GET /members
  # GET /members.json
  def index
    @members = Member.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @members }
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @member }
    end
  end

  # GET /members/new
  # GET /members/new.json
  def new
    @member = Member.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @member }
    end
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(params[:member])

    respond_to do |format|
      if @member.save
        format.html { redirect_to members_url, notice: '用户'+@member.name+'创建成功' }
      else
        format.html { render action: "new" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.json
  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to members_url, notice: '用户信息更新成功.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  #GET /members/1/delete
  def delete
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to members_url }
      format.json { head :no_content }
    end
  end

  def login
    session[:admin_id] = nil
    if request.post?
      member = Member.authenticate(params[:name], params[:password])
      if member
        if member.role == "admin"
          session[:admin_id] = member.id
          redirect_to params[:back_uri] || "/status"
        else
          flash.now[:notice] = "该帐号没有管理员权限"
        end
      else
        flash.now[:notice] = "错误的用户名或密码"
      end
    end
  end

  def logout
    session[:admin_id] = nil
    redirect_to "/admin/login"
  end

end
