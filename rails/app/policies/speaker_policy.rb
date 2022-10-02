class SpeakerPolicy < ApplicationPolicy
  attr_accessor :user

  def initialize(user, speaker)
    @user = user
    @speaker = speaker
  end

  def index?
    user.admin? || user.editor?
  end

  def edit?
    user.admin? || user.editor?
  end

  def update?
    edit?
  end

  def show?
    return false if user.viewer?
    return false if user.super_admin
    true
  end

  def new?
    user.admin? || user.editor?
  end

  def create?
    new?
  end

  def destroy?
    user.admin? || user.editor?
  end

  def import_csv?
    user.admin? || user.editor?
  end

  def delete_photo?
    user.admin? || user.editor?
  end

  class Scope < Scope
    def resolve
      if user.viewer?
        scope.joins(:stories).where(stories: {permission_level: :anonymous}).distinct
      elsif user.member?
        scope.joins(:stories).where(stories: {permission_level: [:anonymous, :user_only]}).distinct
      else
        scope.all
      end
    end

    def resolve_admin
      scope.where(community: user.community)
    end
  end
end
