class CopiesController < ApplicationController

  def show
    @copy = resource
    @book = @copy.book
    @previous_loans = @copy.loans.history
  end

  def new
    @copy = parent.copies.build
  end

  def lookup
    @copy = Copy.find_by_reference(params[:book_reference])

    if @copy
      redirect_to copy_path(@copy)
    else
      flash[:alert] = "Copy #{params[:book_reference]} couldn't be found."
      redirect_to root_path
    end
  end

  def create
    @copy = parent.copies.build(params[:copy])

    if @copy.save
      flash[:notice] = "Copy #{@copy.book_reference} has been added to the library."
      redirect_to book_path(@copy.book)
    else
      render :action => :new
    end
  end

  def borrow
    if resource.borrow(current_user)
      flash[:notice] = "Copy #{resource.book_reference} is now on loan to you."
    end
  rescue Copy::NotAvailable => e
    flash[:alert] = "Copy #{resource.book_reference} is already on loan to #{resource.current_user.name}."
  ensure
    redirect_to copy_path(resource)
  end

  def return
    if resource.return(current_user)
      flash[:notice] = "Copy #{resource.book_reference} has now been returned. Thanks!"
    end
  rescue Copy::NotOnLoan => e
    flash[:alert] = "Copy #{resource.book_reference} is not on loan."
  rescue Copy::NotLoanedByUser => e
    flash[:alert] = "Copy #{resource.book_reference} is not on loan to you, so you cannot return it."
  ensure
    redirect_to copy_path(resource)
  end

  def nudge
    mail = LibraryMailer.nudge_email(resource.current_loan)
    mail.deliver
    flash[:notice] = "A nudge email has been sent to #{resource.current_user.name}."
  rescue Exception => e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    flash[:alert] = "Nudge email could not be sent!"
  ensure
    redirect_to copy_path(resource)
  end

  private
    def parent
      @book = Book.find(params[:book_id])
    end

    def resource
      @copy = Copy.find_by_reference(params[:id]) || not_found
    end

end
