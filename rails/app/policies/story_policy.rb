class StoryPolicy
    class Scope
        attr_reader :user, :story

        def initialize(user, story)
            @user = user
            @story = story
        end

        def resolve
            stories = Story.where(permission_level: :anonymous)
            if user.present?
                stories = Story.where(permission_level: [:anonymous, :user_only])
            end
            if user && user.editor?
                stories = Story.all
            end
            stories
        end
    end
end
