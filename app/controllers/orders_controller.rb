class OrdersController < ApplicationController
  # ログインしていないユーザーはログインページに遷移させる
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]
  before_action :set_public_key, only: [:index, :create] # 公開鍵の設定を共通化
  before_action :redirect_if_seller_or_sold, only: [:index, :create]

  def index
    @order_shipping_address = OrderShippingAddress.new
  end

  def create
    @order_shipping_address = OrderShippingAddress.new(order_params)
    if @order_shipping_address.valid?
      pay_item
      @order_shipping_address.save
      return redirect_to root_path
    end

    # バリデーションに失敗した場合はフォームを再表示
    render :index, status: :unprocessable_entity
  # pay_itemで発生しうるカードエラー（残高不足など）をここで捕捉
  rescue Payjp::CardError => e
    # エラー内容をログに記録し、ユーザーにメッセージを表示
    Rails.logger.error "Pay.jp CardError: #{e.message}"
    @order_shipping_address.errors.add(:token, "カード情報が正しくありません。")
    render :index, status: :unprocessable_entity
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def order_params
    params.require(:order_shipping_address).permit(:postcode, :prefecture_id, :city, :block, :building, :phone_number).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end
  
  def pay_item
    Payjp::Charge.create(
      amount: @item.price,  # 商品の値段
      card: order_params[:token],    # カードトークン
      currency: 'jpy'                 # 通貨の種類（日本円）
    )
  end

  def set_public_key
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
  end

  def redirect_if_seller_or_sold
    redirect_to root_path if current_user.id == @item.user_id || @item.order.present?
  end
end