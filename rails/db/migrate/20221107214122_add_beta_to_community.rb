class AddBetaToCommunity < ActiveRecord::Migration[6.1]
  def change
    add_column :communities, :beta, :boolean, default: false
  end
end
