class CurriculumPolicy < ApplicationPolicy
  attr_accessor :user, :curriculum

  def initialize(user, curriculum)
    @user = user
    @curriculum = curriculum
  end

  def index?
    true
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
