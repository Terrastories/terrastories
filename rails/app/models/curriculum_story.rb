class CurriculumStory < ApplicationRecord
    belongs_to :curriculum
    belongs_to :story
    accepts_nested_attributes_for :story

    def story_desc
        self.story.desc
    end

end

# == Schema Information
#
# Table name: curriculum_stories
#
#  id            :bigint           not null, primary key
#  display_order :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  curriculum_id :bigint           not null
#  story_id      :bigint           not null
#
# Indexes
#
#  index_curriculum_stories_on_curriculum_id  (curriculum_id)
#  index_curriculum_stories_on_story_id       (story_id)
#
# Foreign Keys
#
#  fk_rails_...  (curriculum_id => curriculums.id)
#  fk_rails_...  (story_id => stories.id)
#
