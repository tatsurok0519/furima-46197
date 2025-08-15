class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]


  def index
    @items = Item.with_attached_image.includes(:order).order('created_at DESC')
  end

  # def show
  #   @item = Item.find(params[:id])
  # end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :description, :category_id, :condition_id, :postage_id, :prefecture_id, :shipping_day_id, :price).merge(user_id: current_user.id)
  end
end
