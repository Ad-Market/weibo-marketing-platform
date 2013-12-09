class Province < ActiveRecord::Base
  attr_accessible :id, :name

  has_many :cities

end
