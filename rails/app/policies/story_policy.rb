class StoryPolicy
    class Scope
        attr_reader :user, :story

        def initialize(user, story)
            @user = user
            @story = story
        end

        def resolve
            Rails.logger.debug "User: #{user}"
            if user&.admin?
                Rails.logger.debug 'Admin user gets all stories'
                Story.all
            elif user
                Rails.logger.debug 'Known user gets stories limited to demographics'
                Story.joins(:demographic).where('demographics_stories.demographic_id': user.demographic)
            else
                Rails.logger.debug 'Anonymous user gets only public stories'
                Story.where(permission_level: :anonymous)
            end
        end
    end
end
