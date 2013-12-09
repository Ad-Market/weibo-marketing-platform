class History < ActiveRecord::Base
  attr_accessible :url, :keyword, :search_count,:city,:province
end
