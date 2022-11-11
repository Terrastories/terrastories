module Onboard
  class BaseController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :set_community
  end
end
