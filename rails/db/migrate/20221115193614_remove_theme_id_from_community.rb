class RemoveThemeIdFromCommunity < ActiveRecord::Migration[6.1]
  def change
    remove_column :communities, :theme_id, :integer
  end
end
