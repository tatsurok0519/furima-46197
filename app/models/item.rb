class Item < ApplicationRecord
  # --- Associations ---
  belongs_to :user
  has_one :order
  has_one_attached :image

  # ActiveHash Associations
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :condition
  belongs_to :postage
  belongs_to :prefecture
  belongs_to :shipping_day

  # --- Validations ---
  # 必須項目のバリデーション
  validates :image,       presence: true
  validates :name,        presence: true
  validates :description, presence: true

  # ActiveHashを利用する項目のバリデーション
  # IDが1（"---"）の場合は保存できないようにする
  with_options numericality: { other_than: 1, message: "can't be blank" } do
    validates :category_id
    validates :condition_id
    validates :postage_id
    validates :prefecture_id
    validates :shipping_day_id
  end

  # 価格のバリデーション
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 }
end