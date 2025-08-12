class OrdersController < ApplicationController
  # ログインしていないユーザーはログインページに遷移させる
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]
  before_action :redirect_if_inappropriate, only: [:index, :create]

  def index
    @order_address = OrderAddress.new
  end

  def create
    # フォームから送られてきた情報でフォームオブジェクトを初期化
    @order_address = OrderAddress.new(order_params)
    if @order_address.valid?
      # バリデーションをクリアしたら、データを保存
      @order_address.save
      # トップページにリダイレクト
      redirect_to root_path
    else
      # バリデーションエラーがあれば、購入ページを再表示
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def order_params
    # フォームから送信される情報をフィルタリングし、必要な情報をマージ
    # :token はクレジットカード決済で利用します
    params.require(:order_address).permit(:postal_code, :prefecture_id, :city, :addresses, :building, :phone_number).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end
  
  def redirect_if_inappropriate
    # 出品者自身が購入しようとした場合、または商品が売却済みの場合はトップページへリダイレクト
    redirect_to root_path if @item.user_id == current_user.id || @item.order.present?
  end
end