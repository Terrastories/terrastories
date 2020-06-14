class AddOrderToCurriculumStory < ActiveRecord::Migration[5.2]
  def change
    add_column :curriculum_stories, :order, :integer
  end
end
