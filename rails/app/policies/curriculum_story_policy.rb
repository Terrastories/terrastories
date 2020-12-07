class CurriculumStoryPolicy < ApplicationPolicy
  attr_accessor :user, :curriculum_story

  def initialize(user, curriculum_story)
    @user = user
    @curriculum_story = curriculum_story
  end

  def new?
    user.admin? || user.editor?
  end

  def create?
    new?
  end

  def show?
    true
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

end
