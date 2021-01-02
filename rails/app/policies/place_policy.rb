class PlacePolicy < ApplicationPolicy
  attr_accessor :user, :place

  def initialize(user, place)
    @user = user
    @place = place
  end

  def index?
    user.admin? || user.editor?
  end

  def new?
    user.admin? || user.editor?
  end

  def create?
    new?
  end

  def show?
    # anyone except super admins can view
    !user.super_admin
  end

  def edit?
    user.admin? || user.editor?
  end

  def update?
    edit?
  end

  def destroy?
    user.admin? || user.editor?
  end

  class Scope < Scope
    def resolve_admin
      scope.where(community: user.community)
    end
  end
end
