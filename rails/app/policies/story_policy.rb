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
    def resolve
      if user&.super_admin
        # this is so the admin page doesn't throw a nil error for super admins looking at community dashboard
        stories = scope.all
      elsif user&.editor? || user&.admin?
        stories = scope.where(community: user.community).all
      elsif user&.member?
        stories = scope.where(community: user.community, permission_level: [:anonymous, :user_only])
      else
        stories = scope.where(community: user.community, permission_level: :anonymous)
      end

      stories.eager_load(:speakers, :places)
    end

    def resolve_admin
      scope.where(community: user.community)
    end
  end
end
