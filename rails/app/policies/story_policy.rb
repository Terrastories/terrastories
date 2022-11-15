class StoryPolicy < ApplicationPolicy
  attr_reader :user, :story

  def initialize(user, story)
    @user = user
    @story = story
  end

  def index?
    !user.super_admin
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

  def delete_media?
    user.admin? || user.editor?
  end

  class Scope < Scope
    def resolve
      if user&.super_admin || user&.admin? || user&.editor?
        scope.all
      elsif user&.member?
        scope.where(permission_level: [:anonymous, :user_only])
      else
        scope.where(permission_level: :anonymous)
      end.eager_load(:speakers, :places)
    end

    def resolve_admin
      scope.where(community: user.community)
    end
  end
end
