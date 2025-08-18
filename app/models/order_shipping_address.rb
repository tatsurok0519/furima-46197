class OrderShippingAddress
  # ActiveModel::Modelをincludeすることで、
  # ActiveRecordを継承していなくてもバリデーションなどの機能が使えるようになります。
  include ActiveModel::Model

  # フォームで扱う属性（カラム）をすべて定義します。
  # これが「入れ物」となり、フォームからのデータを受け取ります。
  attr_accessor :user_id, :item_id, :token, :postal_code, :prefecture_id, :city, :street_address, :building_name, :phone_number

  # --- バリデーション ---
  # `with_options`で共通の`presence: true`をまとめています。
  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :token
    validates :city, presence: true
    validates :street_address, presence: true
    # 郵便番号は「3桁ハイフン4桁」の半角文字列のみ許可します。
    validates :postal_code, presence: true, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'is invalid. Include hyphen(-)' }
    # 電話番号は10桁以上11桁以内の半角数値のみ許可します。
    validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/, message: 'is invalid' }
  end

  # 都道府県は「---」が選択されていないことを検証します（idが1以外）。
  validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }

  # データをテーブルに保存する処理
  def save
    # バリデーションを通過しない場合は、ここで処理を中断します。
    return false unless valid?

    # トランザクション処理により、途中でエラーが発生した場合はすべての変更を無かったことにします。
    ActiveRecord::Base.transaction do
      # 最初に購入情報（Order）を保存します。`create!`は失敗時に例外を発生させます。
      order = Order.create!(user_id: user_id, item_id: item_id)
      # 次に配送先情報（ShippingAddress）を保存します。
      ShippingAddress.create!(postal_code: postal_code, prefecture_id: prefecture_id, city: city, street_address: street_address, building_name: building_name, phone_number: phone_number, order_id: order.id)
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end