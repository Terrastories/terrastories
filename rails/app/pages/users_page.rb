class UsersPage < Page
  def initialize(community, meta = {})
    @community = community
    @meta = meta

    @meta[:limit] ||= 20
    @meta[:offset] ||= 0
    @meta[:sort_by] ||= "email"
    @meta[:sort_dir] ||= "asc"
  end

  def relation
    users = @community.users

    users.order(@meta[:sort_by] => @meta[:sort_dir])
  end
end