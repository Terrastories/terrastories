class RoleRoutingConstraint
  def initialize(&block)
    @block = block || lambda { |user| true }
  end

  def matches?(request)
    user = current_user(request)
    puts user
    user.present? && @block.call(user)
  end

  def current_user(request)
    User.find_by(id: request.session["warden.user.user.key"][0][0])
  end
end