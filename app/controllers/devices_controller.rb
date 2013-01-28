class DevicesController < ApplicationController

  before_filter :lookup_device, :only => [:show, :edit, :history, :update]
  has_scope :model_search, :as => :q

  def index
    @books = apply_scopes(Device).all

    if params[:display] == 'list'
      render "list"
    else
      render "grid"
    end
  end

  def new
    @book = Device.new
  end

  def create
    @book = Device.new(params[:device])
    @book.created_by = current_user

    if @book.save
      flash[:notice] = 'Book created'
      redirect_to device_path(@book)
    else
      render :action => :new
    end
  end

  def show
    # show.html.erb
  end

  def edit
    # edit.html.erb
  end

  def history
    # history.html.erb
  end

  def update
    if @book.update_attributes(params[:device])
      flash[:notice] = 'Book updated'
      redirect_to device_path(@book)
    else
      render :action => :edit
    end
  end

  private
    def lookup_device
      @book = Device.includes(:copies).find(params[:id]) || not_found
    end
end
