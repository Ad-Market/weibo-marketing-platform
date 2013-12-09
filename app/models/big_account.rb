class BigAccount < ActiveRecord::Base
  attr_accessible :uid, :screen_name
  has_many :small_accounts, :dependent => :destroy
  has_many :repost_sources
  belongs_to :member
end
