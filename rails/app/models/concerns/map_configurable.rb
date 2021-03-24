module MapConfigurable
  extend ActiveSupport::Concern
  def set_map_defaults
    self.center_lat ||= 38.5
    self.center_long ||= -108
    self.sw_boundary_lat ||= -85
    self.sw_boundary_long ||= -180
    self.ne_boundary_lat ||= 85
    self.ne_boundary_long ||= 180
    self.zoom ||= 3.5
    self.pitch ||= 0
    self.bearing ||= 0
  end

  def center
    @center ||= [center_long, center_lat]
  end

  def sw_boundary
    @sw_boundary ||= [sw_boundary_long, sw_boundary_lat]
  end

  def ne_boundary
    @ne_boundary ||= [ne_boundary_long, ne_boundary_lat]
  end
end
