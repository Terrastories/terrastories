class CommunitiesPage < Page
  def initialize(meta = {})
    @meta = meta

    @meta[:limit] ||= 20
    @meta[:offset] ||= 0
    @meta[:sort_by] ||= "created_at"
    @meta[:sort_dir] ||= "desc"
  end

  def relation
    communities = Community.all

    communities.order(@meta[:sort_by] => @meta[:sort_dir])
  end
end