class AddPublicFlagToCommunity < ActiveRecord::Migration[6.1]
  def change
    add_column :communities, :public, :boolean, default: false, null: false
    add_index :communities, :public
  end
end
