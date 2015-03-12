class CatsController < ApplicationController
  before_action :ensure_owner, only: [:update, :edit]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cats).permit(:name, :color, :birth_date, :description, :sex)
  end

  def ensure_owner
    @cat = Cat.find(params[:id])
    unless current_user.id == @cat.user_id
      flash[:errors] = "You don't own that cat"
      redirect_to root_url
    end
  end

end
