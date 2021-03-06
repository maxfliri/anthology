class Copy < ActiveRecord::Base
  attr_accessible :resource_id, :reference, :on_loan

  belongs_to :resource, :polymorphic => true
  has_many :loans, :dependent => :destroy
  has_many :users, :through => :loans

  validates :reference, :presence => true, :uniqueness => { :case_sensitive => false }

  before_validation :allocate_reference, :on => :create, :if => proc {|c| c.reference.blank? }

  scope :on_loan, where(:on_loan => true)
  scope :available, where(:on_loan => false)
  scope :ordered_by_availability, order("on_loan ASC, reference ASC")
  scope :recently_added, order("created_at DESC")

  class NotAvailable < Exception; end
  class NotOnLoan < Exception; end
  class NotLoanedByUser < Exception; end

  def current_loan
    loans.on_loan.first
  end

  def current_user
    current_loan.user if current_loan
  end

  def on_loan?
    on_loan
  end

  def available?
    ! on_loan
  end

  def status
    on_loan? ? :on_loan : :available
  end

  def update_loan_status!
    self.on_loan = current_loan.present?
    self.save!
  end

  def borrow(user)
    raise NotAvailable unless available?

    loans.create(:user => user)
  end

  def return(user)
    raise NotOnLoan unless on_loan?
    raise NotLoanedByUser, user unless current_user == user

    loans.where(:user_id => user.id, :state => 'on_loan').each(&:return)
  end

  def allocate_reference
    self.reference = (Copy.order("reference desc nulls last").first || Copy.new).reference.to_i + 1
  end

  def to_param
    reference
  end

  alias_attribute :book, :resource
  alias_attribute :book_reference, :reference

end
