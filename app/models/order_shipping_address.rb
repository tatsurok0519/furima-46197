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

    # transaction内で!付きメソッドを使うと、どちらかの保存に失敗した場合、
    # 自動的に処理全体が取り消される（ロールバック）ため、データの整合性が保たれる
    ActiveRecord::Base.transaction do
      order = Order.create!(user_id: user_id, item_id: item_id)
      ShippingAddress.create!(
        postcode: postcode, prefecture_id: prefecture_id, city: city,
        block: block, building: building, phone_number: phone_number,
        order_id: order.id
      )
    end
    true
  rescue ActiveRecord::RecordInvalid
    # transaction内でエラーが発生した場合、falseを返して処理を終える
    false
  end

  private

  def item_exists?
    item_id.present?
  end

  def seller_cannot_be_buyer
    # if: :item_exists? でitemの存在は保証されているため、item&. は不要
    errors.add(:user_id, "can't purchase their own item") if item.user_id == user_id
  end

  def item_is_not_already_sold
    # if: :item_exists? でitemの存在は保証されているため、item&. は不要
    errors.add(:item_id, 'has already been sold') if item.order.present?
  end

  def item
    @item ||= Item.find_by(id: item_id)
  end
end
