class MachineCode < ActiveRecord::Base
  attr_accessible :code
  belongs_to :member
end
