class RemoveRegionColumnFromSpeaker < ActiveRecord::Migration[5.2]
  def change
    remove_column :speakers, :region, :string
  end
end
