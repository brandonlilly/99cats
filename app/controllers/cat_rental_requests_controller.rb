class CatRentalRequestsController < ApplicationController

  def new
    @cats = Cat.all
    @request = CatRentalRequest.new
    render :new
  end

  def create
    @request = CatRentalRequest.new(request_params)

    if @request.save
      redirect_to @request.cat
    else
      @cats = Cat.all
      flash.now[:error] = @request.errors.full_messages
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

end
