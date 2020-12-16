class AddThemeToCommunity < ActiveRecord::Migration[5.2]
  def change
    add_column :communities, :theme_id, :integer, foreign_key: true
  end
end
