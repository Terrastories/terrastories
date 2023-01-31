class UserPolicy < ApplicationPolicy
  attr_accessor :current_user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def index?
    current_user.admin?
  end

  def edit?
    current_user.admin?
  end

  def update?
    edit?
  end

  def show?
    current_user.admin?
  end

  def new?
    current_user.admin?
  end

  def create?
    new?
  end

  def destroy?
    current_user.admin? && user != current_user
  end

  def delete_photo?
    edit?
  end

  class Scope < Scope
    def resolve_admin
      if user.admin?
        scope.where(community: user.community)
      else
        scope.where(id: user.id)
      end
    end
  end
end
