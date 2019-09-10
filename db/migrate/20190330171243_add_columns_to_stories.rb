class AddColumnsToStories < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :date_interviewed, :datetime
    add_column :stories, :interviewer, :string
    add_column :stories, :language, :string
  end
end
