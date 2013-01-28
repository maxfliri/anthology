class Device < ActiveRecord::Base
  attr_accessible :image, :model

  alias_attribute :title, :model

  has_paper_trail

  validates :model, :presence => true

  after_create :setup_first_copy

  has_many :copies, :as => :resource, :dependent => :destroy
  has_many :loans, :through => :copies

  belongs_to :created_by, :class_name => "User"

  scope :model_search, proc {|q| where("model ILIKE ?", "%#{q}%") }

  default_scope order("model ASC")

  def available?
    self.copies.available.any?
  end

  private

  def setup_first_copy
    copy = self.copies.create
    copy
  end
end
