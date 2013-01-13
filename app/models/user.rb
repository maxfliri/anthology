class User < ActiveRecord::Base
  attr_accessible :name, :uid, :nickname, :email, :provider

  has_many :loans, :dependent => :destroy
  has_many :copies, :through => :loans, :conditions => ['loans.state = ?','on_loan']
  has_many :books, :through => :copies

  validates :uid, :presence => true, :uniqueness => {:scope => :provider}

  def current_copies
    copies.includes(:book)
  end

  def previous_loans
    loans.returned.includes(:copy).includes(:book)
  end

  def self.find_or_create_from_auth_hash(auth_hash)
    provider = auth_hash.provider
    uid = auth_hash.uid.to_s
    nickname = auth_hash.info ? auth_hash.info.nickname : nil
    email = auth_hash.info ? auth_hash.info.email : nil

    current_user = self.where(:provider => provider, :uid => uid).first
    if current_user
      current_user.update_attributes(:name => auth_hash.info.name, :nickname => nickname, :email => email)
    else
      current_user = self.create!(:provider => provider, :uid => uid, :name => auth_hash.info.name, :nickname => nickname, :email => email)
    end

    current_user
  end
end
