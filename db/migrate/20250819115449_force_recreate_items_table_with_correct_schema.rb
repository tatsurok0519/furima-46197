class ForceRecreateItemsTableWithCorrectSchema < ActiveRecord::Migration[7.1]
  # 最新のテーブル定義（db/schema.rbからコピーするのが最も確実）
  # この定義が、テーブルのあるべき最終形です。
  def latest_schema(t)
    t.string "name", null: false
    t.text "description", null: false
    t.integer "price", null: false
    t.bigint "user_id", null: false
    t.integer "category_id", null: false
    t.integer "condition_id", null: false
    t.integer "postage_id", null: false
    t.integer "prefecture_id", null: false
    t.integer "shipping_day_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  def up
    # 万が一、古いバックアップテーブルが残っていたら削除する
    drop_table :items_old, if_exists: true

    # 1. 現在のitemsテーブルをバックアップ（退避）させる
    rename_table :items, :items_old

    # 2. 最新の定義で、まっさらなitemsテーブルを再作成する
    create_table :items, &method(:latest_schema)

    # 3. データ移行は行わない（データがないため、これが最も安全で確実）

    # 4. 役目を終えたバックアップテーブルを、関連する制約ごと強制的に削除する
    drop_table :items_old, force: :cascade
  end

  def down
    # このマイグレーションは非常に強力なため、簡単には元に戻せません。
    # もし戻す場合は、バックアップから復元する必要があります。
    raise ActiveRecord::IrreversibleMigration
  end
end