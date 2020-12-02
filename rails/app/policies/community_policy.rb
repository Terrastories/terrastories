class CommunityPolicy < ApplicationPolicy
  def initialize(user, community)
    @user = user
    @community = community
  end

  def index?
    false
  end

  def show?
    user.admin?
  end

  def new?
    false
  end

  def edit?
    user.admin?
  end

  def update?
    edit?
  end

  def destroy?
    false
  end
end
