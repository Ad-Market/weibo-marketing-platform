class RepostContent < ActiveRecord::Base
  attr_accessible :id, :content
  belongs_to :member
end
