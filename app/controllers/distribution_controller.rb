# -*- coding: utf-8 -*-
class DistributionController < ApplicationController
  layout "admin"
  before_filter :admin_authorize
  
  def index
  end

  def get_count_of_users_groupby_province
    search = User.search do
      fulltext ""
      facet :province
      paginate :page=>1, :per_page=>0
    end
    @result = Hash.new
    @result["provinces"] = Array.new
    search.facet(:province).rows.each do |row|
      unless $province_hash[row.value.to_i].nil?
        @result["provinces"] << {
          "name" => $province_hash[row.value.to_i],
          "y" => row.count
        }
      else
        @result["provinces"] << {
          "name" => "未标记",
          "y" => row.count
        }
      end
    end
    respond_to do |format|
      format.json { render json: @result }
    end
  end

  def get_count_of_users_groupby_age
    search = User.search do
      fulltext ""
      facet :age
      paginate :page=>1, :per_page=>0
    end
    @result = Hash.new
    @result["ages"] = Array.new
    search.facet(:age).rows.each do |row|
      unless $age_hash[row.value.to_i].nil?
        @result["ages"] << {
          "name" => $age_hash[row.value.to_i],
          "y" => row.count
        }
      else
        @result["ages"] << {
          "name" => "未标记",
          "y" => row.count
        }
      end
    end
    respond_to do |format|
      format.json { render json: @result }
    end
  end


  def get_count_of_users_groupby_v
    search = User.search do
      fulltext ""
      facet :v
      paginate :page=>1, :per_page=>0
    end
    @result = Hash.new
    @result["vs"] = Array.new
    search.facet(:v).rows.each do |row|
      unless $v_hash[row.value].nil?
        @result["vs"] << {
          "name" => $v_hash[row.value],
          "y" => row.count
        }
      else
        @result["vs"] << {
          "name" => "未标记",
          "y" => row.count
        }
      end
    end
    respond_to do |format|
      format.json { render json: @result }
    end
  end

  def get_count_of_users_groupby_gender
    search = User.search do
      fulltext ""
      facet :gender
      paginate :page=>1, :per_page=>0
    end
    @result = Hash.new
    @result["genders"] = Array.new
    search.facet(:gender).rows.each do |row|
      unless $gender_hash[row.value].nil?
        @result["genders"] << {
          "name" => $gender_hash[row.value],
          "y" => row.count
        }
      else
        @result["genders"] << {
          "name" => "未标记",
          "y" => row.count
        }
      end
    end
    respond_to do |format|
      format.json { render json: @result }
    end
  end


end
