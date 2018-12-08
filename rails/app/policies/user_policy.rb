class UserPolicy < AdminOnlyPolicy
  attr_reader :user, :user_record

  def initialize user, user_record
    @user = user
    @user_record = user_record
  end

  def self?
    user.admin? || user.id == user_record.id
  end

  alias_method :edit?, :self?
  alias_method :show?, :self?
  alias_method :update?, :self?

  class Scope < AdminOnlyPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end
end
