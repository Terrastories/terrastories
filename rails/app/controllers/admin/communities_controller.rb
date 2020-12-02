module Admin
  class CommunitiesController < Admin::ApplicationController
    def find_resource(params)
      current_community
    end
  end
end
