class CatRentalRequestsController < ApplicationController
  before_action :ensure_owner, only: [:approve, :deny]

  def new
    @cats = Cat.all
    @request = CatRentalRequest.new
    render :new
  end

  def create
    @request = CatRentalRequest.new(request_params)
    @request.user_id = current_user.id
    
    if @request.save
      redirect_to @request.cat
    else
      @cats = Cat.all
      flash.now[:errors] = @request.errors.full_messages
      render :new
    end
  end

  def approve
    @request = CatRentalRequest.find(params[:id])
    @request.approve!
    redirect_to @request.cat
  end

  def deny
    @request = CatRentalRequest.find(params[:id])
    @request.deny!
    redirect_to @request.cat
  end

  private

  def request_params
    params.require(:cat_rental_requests)
      .permit(:start_date, :end_date, :cat_id, :status)
  end

  def ensure_owner
    @request = CatRentalRequest.find(params[:id])
    unless current_user.id == @request.cat.user_id
      flash[:errors] = "You do not own this cat"
      redirect_to @request.cat
    end
  end

end
