class StoryPolicy < ApplicationPolicy
  attr_reader :user, :story

  def initialize(user, story)
    @user = user
    @story = story
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

  class Scope < Scope
    def resolve
      stories = user.community.stories.where(permission_level: :anonymous)
      if user.present?
          stories = user.community.stories.where(permission_level: [:anonymous, :user_only])
      end
      if user && user.editor?
          stories = user.community.stories.all
      end
      stories
    end

    def resolve_admin
      scope.where(community: user.community)
    end
  end
end
