class CommunitiesPage < Page
  def initialize(meta = {})
    @meta = meta

    unless %w(name created_at updated_at).include? @meta[:sort_by]
      @meta[:sort_by] = nil
    end

    unless %w(asc desc).include? @meta[:sort_dir]
      @meta[:sort_dir] = nil
    end

    @meta[:limit] ||= 20
    @meta[:offset] ||= 0
    @meta[:sort_by] ||= "updated_at"
    @meta[:sort_dir] ||= "desc"
  end

  def relation
    communities = Community.all

    communities = communities.where("name ILIKE :name", name: "%#{@meta[:name]}%") if @meta[:name].present?

    communities.order(@meta[:sort_by] => @meta[:sort_dir])
  end
end
