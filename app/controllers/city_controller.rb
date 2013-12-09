# -*- coding: utf-8 -*-
class CityController < ApplicationController
  
  # GET /citys
  # GET /citys.json
  def index
    @cities = City.where("province_id = ?", params[:province].to_i)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cities }
    end
  end

  # GET /citys/1
  # GET /citys/1.json
  def show
    @city = City.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @city }
    end
  end

  # GET /citys/new
  # GET /citys/new.json
  def new
    @city = City.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @city }
    end
  end

  # GET /citys/1/edit
  def edit
    @city = City.find(params[:id])
  end

  # POST /citys
  # POST /citys.json
  def create
    @city = City.new(params[:city])

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: '新建成功' }
        format.json { render json: @city, status: :created, location: @city }
      else
        format.html { render action: "new" }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /citys/1
  # PUT /citys/1.json
  def update
    @city = City.find(params[:id])

    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to citys_url}
        # format.html { redirect_to @city, notice: '更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /citys/1
  # DELETE /citys/1.json
  #def destroy
  #  @city = city.find(params[:id])
  #  @city.destroy

  #  respond_to do |format|
  #    format.html { redirect_to citys_url }
  #    format.json { head :no_content }
  #  end
  #end

  #/citys/1/delete
  def delete
    @city = City.find(params[:id])
    @city.destroy

    respond_to do |format|
      format.html { redirect_to cities_url }
      format.json { head :no_content }
    end

  end

end
