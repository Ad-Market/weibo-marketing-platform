# -*- coding: utf-8 -*-
require 'digest/sha1'
class Member < ActiveRecord::Base
  attr_accessible :at_permission, :follow_permission, :hashed_password, 
    :name, :platform_permission, :role, :saltm, :password, :password_confirmation,
    :utype, :search_permission, :comm_permission, :lbs_permission, :ads_permission,
    :repost_permission, :export_permission, :repost_interval, :uid, :weibo_name,
    :token, :expires_at, :avatar, :money, :bind_limit

  has_many :big_accounts, :dependent => :destroy
  has_many :repost_contents, :dependent => :destroy
  has_many :machine_codes, :dependent => :destroy

  #validates_presence_of     :name
  #validates_uniqueness_of   :name

  attr_accessor
  #validates_confirmation_of :password
  #validate :password_non_blank

  def self.authenticate(name, password)
    member = self.find_by_name(name)
    if member
      expected_password = encrypted_password(password, member.salt)
      if member.hashed_password != expected_password
        member = nil
      end
    end
    member
  end

  # password is a virtual attribute
  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = Member.encrypted_password(self.password, self.salt)
  end

private

  def password_non_blank
    errors.add_to_base("密码不能为空") if hashed_password.blank?
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "bridge21" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

end
