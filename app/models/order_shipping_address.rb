class OrderShippingAddress
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :token, :postcode, :prefecture_id, :city, :block, :building, :phone_number

  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :token
    validates :city
    validates :block
    validates :postcode, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'is invalid. Include hyphen(-)' }
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: 'is invalid. Input only number' }
  end

  validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }

  # カスタムバリデーションは、privateの外側（クラスの直下）に記述します
  validate :seller_cannot_be_buyer
  validate :item_is_not_already_sold

  def save
    # valid?でバリデーションを実行し、NGならここで処理を終える
    return false unless valid?

    # データベースへの保存処理をbegin-rescueで囲み、予期せぬエラーを捕捉する
    begin
      # transaction内で!付きメソッドを使い、データの整合性を保つ
      ActiveRecord::Base.transaction do
        order = Order.create!(user_id: user_id, item_id: item_id)
        ShippingAddress.create!(postcode: postcode, prefecture_id: prefecture_id, city: city, block: block, building: building, phone_number: phone_number, order_id: order.id)
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
      # データベースレベルでエラーが発生した場合（例：売り切れのタイミングでの重複購入）
      # ログにエラーを記録し、errorsオブジェクトにメッセージを追加してfalseを返す
      Rails.logger.error("Order creation failed: #{e.message}")
      errors.add(:base, 'An error occurred during purchase. Please try again.')
      return false
    end
    true
  end

  private

  def seller_cannot_be_buyer
    return if item.nil?
    errors.add(:user_id, "can't purchase their own item") if item.user_id == user_id
  end

  def item_is_not_already_sold
    return if item.nil?
    errors.add(:item_id, 'has already been sold') if item.order.present?
  end

  def item
    @item ||= Item.find_by(id: item_id)
  end
end
