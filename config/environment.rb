# -*- coding: utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)
require 'dalli'

# Initialize the rails application
WeiboMarketingPlatform::Application.initialize!

# config the memcached
CACHE = Dalli::Client.new '192.168.13.239:11211'

# define globle status code
module StatusCode
  DONE = 2
  NORMAL = 1
  NO_ITEMS = -1
  COOKIE_ERROR = -2
  NO_COOKIE = -3
  INVALID_PAGE = -4
  MATCH_ERROR = -5
  ALL_ZERO = -6
  USER_UNEXIST = -7
  ALL_COOKIE_ERROR = -8
end

provinces = Province.all
cities = City.all
$province_hash = {}
$city_hash = {}
# province_hash
provinces.each do |prov|
  $province_hash[prov.id] = prov.name
end

# city_hash
cities.each do |city|
  $city_hash["#{city.province_id} #{city.city_id}"] = city.name
end

# gender_hash
$gender_hash = {
  "" => "未知",
  "man" => "男",
  "woman" => "女",
  "all" => "未知"
}

# age_hash
$age_hash = {
  0 => "未知",
  18 => "18岁以下",
  22 => "19-22岁",
  29 => "23-29岁",
  39 => "30-39岁",
  40 => "40岁以上"
}

# v_hash
$v_hash = {
  "vip" => "认证用户",
  "ord" => "普通用户",
  "" => "未知",
  "all" => "未知"
}

$generated_csv_files = {}
