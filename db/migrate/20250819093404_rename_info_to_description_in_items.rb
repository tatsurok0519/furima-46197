class RenameInfoToDescriptionInItems < ActiveRecord::Migration[7.1]
  def change
    # 本番環境でinfoとdescriptionカラムが両方存在してしまっている問題に対応する
    # itemsテーブルにinfoカラムとdescriptionカラムが両方存在する場合
    if column_exists?(:items, :info) && column_exists?(:items, :description)
      puts "Both info and description columns exist. Merging data and removing info column."
      # descriptionが空の場合に限り、infoのデータをdescriptionにコピーする
      execute "UPDATE items SET description = info WHERE description IS NULL OR description = '';"
      # 古いinfoカラムを削除する
      remove_column :items, :info
    # infoカラムだけが存在する（正常な）場合
    elsif column_exists?(:items, :info)
      rename_column :items, :info, :description
    end

    # infoカラムが存在しない場合は、すでに対応済みとみなし、何もしない
  end
end