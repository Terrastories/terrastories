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
            elsif user
                Rails.logger.debug 'Known user gets stories limited to demographics'
                demographics_ids = user.demographic.map(&:id)
                Story.joins(:demographic).where([
                  "`demographics`.`id` = :demo OR `permission_level` = :anon",
                  {demo: demographics_ids, anon: :anonymous}
                ])
                # Story.joins(:demographic).where('demographics.id': demographics_ids)
            else
                Rails.logger.debug 'Anonymous user gets only public stories'
                Story.where(permission_level: :anonymous)
            end
        end
    end
end
