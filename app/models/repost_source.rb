class RepostSource < ActiveRecord::Base
  attr_accessible :wid, :content, :source, :create_time
  belongs_to :big_account
end
