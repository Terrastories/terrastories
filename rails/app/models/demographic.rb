class Demographic < ApplicationRecord
  has_and_belongs_to_many :user
  has_and_belongs_to_many :story

  def user_candidates(user)
    UserPolicy::Scope.new(user, self.user).resolve
  end

  def story_candidates(user)
    StoryPolicy::Scope.new(user, self.story).resolve
  end
end
