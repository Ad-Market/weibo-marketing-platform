# -*- coding: utf-8 -*-
require 'csv'
#require 'fastercsv'
class SearchController < ApplicationController

  before_filter :require_weibo_login
  before_filter :require_advanced_rights, :only => [:export, :index, :generate_csv, :statistics, :export_statistics]

  def index
  end
  
  def result
    url_query = get_search_query(params)
    like_query = url_query["likequery"]
    equal_query = url_query["equalquery"]
    search = User.search do
     if !like_query["fulltext"].nil?
      fulltext like_query["fulltext"]
     else
      like_query.each do |k,v|
        fulltext v do
          fields(k.to_sym)
        end
      end
      equal_query.each do |k,v|
      	v = v.to_i if v.to_i.to_s == v
        with(k.to_sym, v)
      end
     end
     paginate :page =>params[:page]||1 , :per_page => 20
    end
    @users = search.results
    respond_to do |format|
    	 format.html
    end
  end

  def statistics
    @key = params[:key]
  end

  # TODO
  def export_statistics
  end

  def get_count_of_users_groupby_province
    # parse the params
    url_query = get_search_query(params)
    like_query = url_query["likequery"]
    equal_query = url_query["equalquery"]
    # construct a solr query by the params
    search = User.search do
      if !like_query["fulltext"].nil?
        fulltext like_query["fulltext"]
      else
        like_query.each do |k,v|
          fulltext v do
            fields(k.to_sym)
          end
        end
        equal_query.each do |k,v|
          v = v.to_i if v.to_i.to_s == v
          with(k.to_sym, v)
        end
      end
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

  def get_count_of_users_groupby_gender
    url_query = get_search_query(params)
    like_query = url_query["likequery"]
    equal_query = url_query["equalquery"]
    # construct a solr query by the params
    search = User.search do
      if !like_query["fulltext"].nil?
        fulltext like_query["fulltext"]
      else
        like_query.each do |k,v|
          fulltext v do
            fields(k.to_sym)
          end
        end
        equal_query.each do |k,v|
          v = v.to_i if v.to_i.to_s == v
          with(k.to_sym, v)
        end
      end
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

  def get_count_of_users_groupby_v
    # parse the params
    url_query = get_search_query(params)
    like_query = url_query["likequery"]
    equal_query = url_query["equalquery"]
    # construct a solr query by the params
    search = User.search do
      if !like_query["fulltext"].nil?
        fulltext like_query["fulltext"]
      else
        like_query.each do |k,v|
          fulltext v do
            fields(k.to_sym)
          end
        end
        equal_query.each do |k,v|
          if v.to_i.to_s == v
            v = v.to_i
          end
          with(k.to_sym, v)
        end
      end
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

  def get_count_of_users_groupby_age
    # parse the params
    url_query = get_search_query(params)
    like_query = url_query["likequery"]
    equal_query = url_query["equalquery"]
    # construct a solr query by the params
    search = User.search do
      if !like_query["fulltext"].nil?
        fulltext like_query["fulltext"]
      else
        like_query.each do |k,v|
          fulltext v do
            fields(k.to_sym)
          end
        end
        equal_query.each do |k,v|
          if v.to_i.to_s == v
            v = v.to_i
          end
          with(k.to_sym, v)
        end
      end
      facet :age
      paginate :page=>1, :per_page=>0
    end
    @result = Hash.new
    @result["ages"] = Array.new
    search.facet(:age).rows.each do |row|
      unless $province_hash[row.value.to_i].nil?
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

  def get_export_percent
    headers['Last-Modified'] = Time.now.httpdate
    render json: {
      :export_percent => CACHE.get("export_percent_hash_#{session[:uid]}")
    }
  end

  def generate_csv
    url_query = get_search_query(params)
    like_query = url_query["likequery"]
    equal_query = url_query["equalquery"]
    users_of_all_pages = []
    page_num = 1
    status_code = 1
    CACHE.set "export_percent_hash_#{session[:uid]}", 0.0
    begin
      search = User.search do
        if !like_query["fulltext"].nil?
          fulltext like_query["fulltext"]
        else
          like_query.each do |k,v|
            fulltext v do
              fields(k.to_sym)
            end
          end
          equal_query.each do |k,v|
            v = v.to_i if v.to_i.to_s == v
            with(k.to_sym, v)
          end
        end
        paginate :page => page_num, :per_page => 5000
      end
      if search.total > 400000
        CACHE.set("export_percent_hash_#{session[:uid]}", 1)
        status_code = -1
        break
      end
      users_of_all_pages += search.results
      page_num += 1
      CACHE.set("export_percent_hash_#{session[:uid]}", ((page_num*5000)/search.total.to_f > 1) ? 1 : (page_num*5000)/search.total.to_f)
      export_percent_hash_id = "export_percent_hash_#{session[:uid]}"
      logger.info("#{search.total} #{CACHE.get(export_percent_hash_id)}")
    end while !search.results.next_page.nil?
    if status_code == -1
      render json: {:status => -1}
    else
     $generated_csv_files[session[:uid]] = users_of_all_pages
     render json: {:status => 1}
    end
  end

  #export
  def export
    users_of_all_pages = $generated_csv_files[session[:uid]]
    $generated_csv_files[session[:uid]] = nil
    CACHE.delete("export_percent_hash_#{session[:uid]}")
    respond_to do |format|
      format.csv {
        send_data(csv_content_for(users_of_all_pages),
          :type => "text/csv;charset=utf-8; header=present",
          :filename => "Report_Users_#{Time.now.strftime("%Y%m%d")}.csv")
      }

      def csv_content_for(objs)
        CSV.generate do |csv|
          csv << ["微博ID", "昵称", "年龄", "微博数", "粉丝数", "关注人数", "省份", "城市", "用户类型", "标签","学校", "工作", "Email", "QQ", "MSN"]
          objs.each do |record|
            csv << [
              record.uid,
              record.screen_name,
              $age_hash[record.age],
              record.weibo_count,
              record.fans_count,
              record.followers_count,
              $province_hash[record.province],
              $city_hash[record.province.to_s + " " + record.city.to_s],
              $v_hash[record.v],
              record.tags,
              delete_dollar(record.school),
              delete_dollar(record.job),
              record.email,
              record.qq,
              record.msn
            ]
          end
        end
      end
    end
    users_of_all_pages = nil
    GC.start
  end


 protected 
  #parse the parameters in request
  def get_search_query(params_hash)
    query = Hash.new
    key = params_hash[:key]
    equal_query = Hash.new
    like_query = Hash.new
    like_condition = ["job","tags","school","screen_name"]
    equal_condition = ["age","province","city","v","fans_count","followers_count","weibo_count","gender"]

    if !key.nil?
      like_query["fulltext"] = key
      query["likequery"] = like_query
      return query
    end

    params_hash.each do |k,v| 
      if (equal_condition.include? k) && (v!="all")
        equal_query[k] = v
      end
      if (like_condition.include? k) && (v!="")
        like_query[k] = v
      end
    end
    query["likequery"] = like_query
    query["equalquery"] = equal_query
    return query 
  end
 
  def delete_dollar(sentence)
    sentence.nil?? nil : sentence.gsub('$','')
  end
end
