class Cook < ActiveRecord::Base
  attr_accessible :content, :expired, :page_type, :username, :passwd, :frequent, :forbidden, :owner, :remark#, :uid, :forbidden
end
