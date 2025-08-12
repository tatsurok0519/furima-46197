class OrderAddress
  include ActiveModel::Model

  # フォームで扱う属性と、コントローラーから渡される属性を定義します
  attr_accessor :user_id, :item_id, :postal_code, :prefecture_id, :city, :addresses, :building, :phone_number, :token

  # バリデーションをここに記述します
  with_options presence: true do
    # 郵便番号は「3桁ハイフン4桁」の半角文字列のみ許可
    validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: "is invalid. Include hyphen(-)" }
    validates :city
    validates :addresses
    # 電話番号は10桁以上11桁以内の半角数値のみ許可
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: "is invalid" }
    validates :token # クレジットカード情報のトークン
    validates :user_id
    validates :item_id
  end
  # 都道府県は「---」以外が選択されていることを確認
  validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }

  def save
    # 注文情報を保存し、変数orderに代入します
    order = Order.create(user_id: user_id, item_id: item_id)
    # 配送先情報を保存します
    Address.create(postal_code: postal_code, prefecture_id: prefecture_id, city: city, addresses: addresses, building: building, phone_number: phone_number, order_id: order.id)
  end
end