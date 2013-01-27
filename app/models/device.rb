class Device < ActiveRecord::Base
  attr_accessible :image, :model

  validates :model, :presence => true
end
