# -*- coding: utf-8 -*-
namespace :Count do

  desc "Count tag"
  task :count_tag,[:province,:city,:start,:limit]  => :environment do |t, args|

   limit_row = args[:limit].to_i #every time get uid num
   start_uid = args[:start].to_i #start index
   province  = args[:province].to_i #start index
   city = args[:city].to_i #start index

   while(true) do
    p "start uid " +  start_uid.to_s
    uids = User.select("uid").where("uid > ? and city = ? and province = ? and tags is not null and tags != ''", start_uid,city,province).limit(limit_row).order("uid asc")
    if uids.length == 0 then break end
    start_uid = uids.last.uid # update start_uid
    uids.each_with_index do |uid,index|
      temp_user = User.find_by_uid(uid.uid)
      next if temp_user.tags.nil?
      tags = temp_user.tags.split
      tags.each do |t|
        temp_tag = Tag.find_by_tag(t)
        if !temp_tag.nil?
          temp_tag.count = temp_tag.count + 1
        else
          temp_tag = Tag.new
          temp_tag.count = 1
          temp_tag.tag  = t
        end
        temp_tag.save
      end
    end
   end
  end
end
