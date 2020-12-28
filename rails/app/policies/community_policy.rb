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
    true
  end

  def new?
    user.super_admin
  end

  def create?
    new?
  end

  def edit?
    user.super_admin || user.admin?
  end

  def update?
    edit?
  end

  def destroy?
    user.super_admin
  end
end
