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

  def show?
    true
  end

  def edit?
    user.admin? || user.editor?
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
