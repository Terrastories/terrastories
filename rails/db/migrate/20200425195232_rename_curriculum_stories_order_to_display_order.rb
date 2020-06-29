class RenameCurriculumStoriesOrderToDisplayOrder < ActiveRecord::Migration[5.2]
  def change
    rename_column :curriculum_stories, :order, :display_order
  end
end
