class StoryPolicy < EditorOnlyPolicy
  class Scope < EditorOnlyPolicy::Scope
    attr_reader :user, :story

    def initialize(user, story)
      @user = user
      @story = story
    end

    def resolve
      if user&.admin?
        Story.all
      elsif user
        demographics_ids = user.demographic.pluck(:id)
        Story.where('demographics.id': demographics_ids)
          .or(Story.where('stories.is_public': true))
          .left_joins(:demographic)
      else
        Story.where(is_public: true)
      end
    end
  end
end
