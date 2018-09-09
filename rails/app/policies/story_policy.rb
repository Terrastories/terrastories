class StoryPolicy
    attr_reader :user, :story

    def initialize(user, story)
        @user = user
        @story = story
    end

    def update?
        user.editor?
    end

    def resolve
        stories = Story.all
        stories.reject! { |story| story.PERMISSION_LEVEL == 'editor' } unless user.editor?
        stories
    end
end
