require 'test_helper'

class CopyTest < ActiveSupport::TestCase

  setup do
    @book = FactoryGirl.create(:book)
  end

  should "return the book reference as the url parameter" do
    copy = FactoryGirl.create(:copy, :reference => "123")
    assert_equal 123, copy.to_param
  end

  context "creating a new copy" do
    should "increment the book reference" do
      first_copy = @book.copies.first # already created on book creation
      second_copy = @book.copies.create!(:reference => 2)
      third_copy = @book.copies.create!

      assert_equal 1, first_copy.book_reference.to_i
      assert_equal 2, second_copy.book_reference.to_i
      assert_equal 3, third_copy.book_reference.to_i
    end

    should "not allow duplicate book references" do
      first_copy = @book.copies.create!(:reference => 30)
      second_copy = @book.copies.build(:reference => 30)

      assert_equal 30, first_copy.book_reference.to_i
      assert ! second_copy.valid?
    end

    should "set on_loan to false by default" do
      copy = @book.copies.create!

      assert_equal false, copy.on_loan
    end

    should "have no loans by default" do
      copy = @book.copies.create!

      assert_equal 0, copy.loans.count
    end
  end

  context "borrowing a book" do
    setup do
      @user = FactoryGirl.create(:user)
    end

    should "not allow a book already on loan to be borrowed" do
      copy = FactoryGirl.create(:copy_on_loan)

      assert_raise Copy::NotAvailable do
        copy.borrow(@user)
      end
    end

    should "create a new loan" do
      copy = FactoryGirl.create(:copy)
      copy.borrow(@user)

      assert_equal 1, copy.loans.count
    end

    should "find the current loan" do
      copy = FactoryGirl.create(:copy)
      copy.borrow(@user)

      assert_equal copy.current_loan, copy.loans.first
      assert_equal copy.current_loan.user_id, @user.id
    end

    should "find the current user" do
      copy = FactoryGirl.create(:copy)
      copy.borrow(@user)

      assert_equal @user.id, copy.current_user.id
    end
  end

  context "returning a copy" do
    setup do
      @copy_on_loan = FactoryGirl.create(:copy_on_loan)
      @user = @copy_on_loan.current_user
    end

    should "not allow a copy not on loan to be returned" do
      copy = FactoryGirl.create(:copy)

      assert_raise Copy::NotOnLoan do
        copy.return(@user)
      end
    end

    should "only try to return current loans" do
      previous_loan = @copy_on_loan.loans.create!(:user => @user, :state => 'returned')

      assert_nothing_raised do
        @copy_on_loan.return(@user)
      end
    end

    should "not allow a copy loaned by someone else to be returned" do
      another_user = FactoryGirl.create(:user)

      assert_raise Copy::NotLoanedByUser do
        @copy_on_loan.return(another_user)
      end
    end
  end

  context "recently added copies" do
    should "return newest copies first" do
      # delete first auto-generated copy of book
      @book.copies.delete_all

      copies = [
        FactoryGirl.create(:copy, :reference => 101, :book => @book),
        FactoryGirl.create(:copy, :reference => 201, :book => @book),
        FactoryGirl.create(:copy, :reference => 301, :book => @book)
      ]
      assert_equal 301, Copy.recently_added.first.book_reference
      assert_equal 101, Copy.recently_added.last.book_reference
    end
  end

end
