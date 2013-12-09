class User < ActiveRecord::Base
  attr_accessible :age, :birthday, :certification, :city, :daren, :description, :email, :fans_count, :followers_count, :gender, :has_contact, :has_name, :job, :msn, :province, :qq, :school, :screen_name, :tags, :uid, :v, :weibo_count, :has_index
  
  searchable do
     long :uid
     text :description, :school, :job, :tags, :screen_name,:certification,:daren
     integer :age
     integer :city
     string :gender
     string :v
     integer :province
     long :followers_count
     long :fans_count
     long :weibo_count
     string :email
     string :qq
     string :msn
     string :birthday
  end

end
