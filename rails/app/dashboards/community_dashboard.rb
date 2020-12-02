require "administrate/base_dashboard"

class CommunityDashboard < Administrate::BaseDashboard
  def display_resource(community)
    community.name
  end
end
