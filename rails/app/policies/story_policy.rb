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
                Story.all
            elsif user
                demographics_ids = user.demographic.map(&:id)
                Story.joins(:demographic).where([
                  "`demographics`.`id` = :demo OR `is_public` IS TRUE",
                  {demo: demographics_ids, anon: :anonymous}
                ])
            else
                Story.where(is_public: true)
            end
        end
    end
end
