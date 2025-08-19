class FixItemsTableSchema < ActiveRecord::Migration[7.1]
  def change
    # --- カラム名の変更 ---
    # sales_status_id が存在すれば、condition_id に名前を変更します
    if column_exists?(:items, :sales_status_id)
      rename_column :items, :sales_status_id, :condition_id
    end

    # shipping_fee_status_id が存在すれば、postage_id に名前を変更します
    if column_exists?(:items, :shipping_fee_status_id)
      rename_column :items, :shipping_fee_status_id, :postage_id
    end

    # scheduled_delivery_id が存在すれば、shipping_day_id に名前を変更します
    if column_exists?(:items, :scheduled_delivery_id)
      rename_column :items, :scheduled_delivery_id, :shipping_day_id
    end

    # --- 不要なinfoカラムの処理 ---
    # もし古いinfoカラムがまだ存在していれば、データをdescriptionにコピーしてから削除します
    if column_exists?(:items, :info)
      # descriptionが空の場合に限り、infoのデータをdescriptionにコピー
      execute "UPDATE items SET description = info WHERE description IS NULL OR description = '';"
      # 古いinfoカラムを削除
      remove_column :items, :info
    end
  end
end