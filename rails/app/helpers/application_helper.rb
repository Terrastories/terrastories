module ApplicationHelper
  def map_style_url
    ENV['MAP_STYLE_URL'] || '/tiles/styles/basic/style.json'
  end
end
