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

end
