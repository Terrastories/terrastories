module MapConfigurable
  extend ActiveSupport::Concern
  def set_map_defaults
    self.center_lat ||= 15
    self.center_long ||= 0
    self.sw_boundary_lat ||= nil #-85
    self.sw_boundary_long ||= nil #-180
    self.ne_boundary_lat ||= nil #85
    self.ne_boundary_long ||= nil #180
    self.zoom ||= 2
    self.pitch ||= 0
    self.bearing ||= 0
  end

  def center
    @center ||= [center_long, center_lat]
  end

  def sw_boundary
    if sw_boundary_long != nil and sw_boundary_lat != nil
      @sw_boundary ||= [sw_boundary_long, sw_boundary_lat]
    else
      @sw_boundary ||= nil
    end
  end

  def ne_boundary
    if ne_boundary_long != nil and ne_boundary_lat != nil
      @ne_boundary ||= [ne_boundary_long, ne_boundary_lat]
    else
      @ne_boundary ||= nil
    end
  end

  def boundaries
    if sw_boundary != nil and ne_boundary != nil
       [sw_boundary, ne_boundary]
    else
       nil
    end
  end
end
