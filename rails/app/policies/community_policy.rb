class CommunityPolicy < ApplicationPolicy
  attr_reader :user, :community
  def initialize(user, community)
    @user = user
    @community = community
  end

  def index?
    user.super_admin
  end

  def show?
    return true if user.super_admin
    return true if user.admin? &&
      (Flipper.enabled?(:split_settings, community) || Flipper.enabled?(:public_community, community))

    false
  end

  def new?
    user.super_admin
  end

  def create?
    new?
  end

  def edit?
    user.super_admin || (user.admin? &&
      (Flipper.enabled?(:split_settings, community) || Flipper.enabled?(:public_community, community)))
  end

  def update?
    edit?
  end

  def destroy?
    user.super_admin
  end
end
