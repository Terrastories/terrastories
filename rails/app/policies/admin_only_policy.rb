class AdminOnlyPolicy
  def admin?
    user.admin?
  end

  alias_method :destroy?, :admin?
  alias_method :edit?, :admin?
  alias_method :new?, :admin?
  alias_method :show?, :admin?
  alias_method :update?, :admin?

  class Scope
    attr_reader :user, :scope

    def initialize user, scope
      @user = user
      @scope = scope
    end
  end
end
