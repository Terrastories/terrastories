module SuperAdmin
  class MetricsController < BaseController
    def show
      render locals: {
        places_count: Place.all.size,
        stories_count: Story.all.size,
        speakers_count: Speaker.all.size,
        communities_count: Community.all.size,
        users_count: User.all.size
      }
    end
  end
end
