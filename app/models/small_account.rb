class SmallAccount < ActiveRecord::Base
  attr_accessible :id, :uid, :username, :password, :status, :content, :last_repost_time
  belongs_to :big_account
end