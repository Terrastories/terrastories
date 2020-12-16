# NOTE: TODO - this is not currently tied to a Community
# Therefore, everything is labeled as false until we can come
# back through and properly associate curricula and their stories to
# a specific community.

class CurriculumPolicy < ApplicationPolicy
  attr_accessor :user, :curriculum

  def initialize(user, curriculum)
    @user = user
    @curriculum = curriculum
  end

  def index?
    false
  end

  def new?
    false
  end

  def create?
    new?
  end

  def show?
    false
  end

  def edit?
    false
  end

  def update?
    edit?
  end

  def destroy?
    false
  end

end
