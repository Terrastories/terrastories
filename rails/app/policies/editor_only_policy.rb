class EditorOnlyPolicy
  attr_reader :user

  def initialize user, resource
    @user = user
  end

  def editor?
    user.editor?
  end

  alias_method :destroy?, :editor?
  alias_method :edit?, :editor?
  alias_method :new?, :editor?
  alias_method :show?, :editor?
  alias_method :update?, :editor?

  class Scope
    attr_reader :user, :scope

    def initialize user, scope
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
