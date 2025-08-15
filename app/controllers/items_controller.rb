class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show]


  def index
    @items = Item.with_attached_image.includes(:user, :order).order('created_at DESC')
  end

  def show
  end

  def new
    @item = Item.new
  end

  # def edit
  # end

  # def update
  #   if @item.update(item_params)
  #     redirect_to item_path(@item)
  #   else
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

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

  def set_item
    @item = Item.find(params[:id])
  end

  # def redirect_if_not_owner_or_sold
  #   redirect_to root_path if @item.user_id != current_user.id || @item.order.present?
  # end
end
