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
                  "`demographics`.`id` = :demo OR `permission_level` = :anon",
                  {demo: demographics_ids, anon: :anonymous}
                ])
            else
                Story.where(permission_level: :anonymous)
            end
        end
    end
end
