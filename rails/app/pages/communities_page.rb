class CommunitiesPage < Page
  SORTABLE_BY = %w(name created_at updated_at)

  def initialize(meta = {})
    @meta = meta

    @meta[:limit] ||= 20
    @meta[:offset] ||= 0
    @meta[:sort_by] = sort_by
    @meta[:sort_dir] = sort_dir
  end

  def relation
    communities = Community.all

    communities = communities.where("name ILIKE :name", name: "%#{@meta[:name]}%") if @meta[:name].present?

    communities.order(sort_by => sort_dir)
  end

  private

  def sort_by
    SORTABLE_BY.include?(@meta[:sort_by]) ? @meta[:sort_by] : "updated_at"
  end

  def sort_dir
    %w(asc desc).include?(@meta[:sort_dir]) ? @meta[:sort_dir] : "desc"
  end
end
