class WelcomeController < ApplicationController
  def index
    @theme = Theme.find_by(active: true)
  end

end
