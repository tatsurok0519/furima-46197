class RenameInfoToDescriptionInItems < ActiveRecord::Migration[7.1]
  def change
    rename_column :items, :info, :description
  end
end
