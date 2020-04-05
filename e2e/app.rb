require 'pages/home'

class App
  attr_accessor :current_page

  def go_to_homepage
    self.current_page = Pages::Home.new
    current_page.load
  end
end
