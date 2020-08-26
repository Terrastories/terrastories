class CurriculumStory < ApplicationRecord
    belongs_to :curriculum
    belongs_to :story
    accepts_nested_attributes_for :story

    def story_desc
        self.story.desc
    end

end
