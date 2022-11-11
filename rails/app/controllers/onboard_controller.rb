class OnboardController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :set_community

  def start
    # Create a super admin account if one doesn't exist, just in case.
    super_user = User.find_or_initialize_by(username: "terrastories-super")
    super_user.attributes = {
      password: "terrastories",
      super_admin: true,
      role: 100
    }
    super_user.save
  end
end
