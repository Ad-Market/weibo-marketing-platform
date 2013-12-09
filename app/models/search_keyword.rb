class SearchKeyword < ActiveRecord::Base
  attr_accessible :word_frequency, :search_count, :keyword,:result_count,:search_url,:url_type
                  
end
