class RenameColumnsInItems < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :info, :description
    rename_column :items, :sales_status_id, :condition_id
    rename_column :items, :shipping_fee_status_id, :postage_id
    rename_column :items, :scheduled_delivery_id, :shipping_day_id
  end
end