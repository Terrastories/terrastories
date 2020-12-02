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
    true
  end

  def new?
    user.admin? || user.editor?
  end

  def destroy?
    user.admin? || user.editor?
  end
end
