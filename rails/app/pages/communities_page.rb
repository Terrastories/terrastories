class CommunitiesPage < Page
  def initialize(meta = {})
    @meta = meta

    @meta[:limit] ||= 20
    @meta[:offset] ||= 0
    @meta[:sort_by] ||= "name"
    @meta[:sort_dir] ||= "asc"
  end

  def relation
    communities = Community.all

    communities = communities.where("name ILIKE :name", name: "%#{@meta[:name]}%") if @meta[:name].present?

    communities.order(@meta[:sort_by] => @meta[:sort_dir])
  end
end