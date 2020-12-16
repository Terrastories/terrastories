class RemoveBackgroundImgFromTheme < ActiveRecord::Migration[5.2]
  def change
    remove_column :themes, :background_img, :string
  end
end
