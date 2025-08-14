class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string     :name,              null: false
      t.text       :description,       null: false
      t.integer    :category_id,       null: false
      t.integer    :condition_id,      null: false
      t.integer    :postage_id,        null: false
      t.integer    :prefecture_id,     null: false
      t.integer    :shipping_day_id,   null: false
      t.integer    :price,             null: false
      t.references :user,              null: false, foreign_key: true

      t.timestamps
    end

    # DBレベルでのデータ整合性を保つため、価格帯に制約を追加します。
    # (例: 300円〜9,999,999円)
    add_check_constraint :items, 'price BETWEEN 300 AND 9999999', name: 'items_price_check'
  end
end