class City < ActiveRecord::Base
  attr_accessible :id, :city_id, :province_id, :name

  belongs_to :province
end
