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
    # anyone except super admins can view
    !user.super_admin
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

  class Scope < Scope
    def resolve_admin
      scope.where(community: user.community)
    end
  end
end
