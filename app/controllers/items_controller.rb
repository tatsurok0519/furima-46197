class ItemsController < ApplicationController
  # ログインしていないユーザーは、一覧と詳細ページ以外にはアクセスできません。
  before_action :authenticate_user!, except: [:index, :show]


  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price, :image)
  end
end
