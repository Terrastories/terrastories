class User < ApplicationRecord
  has_and_belongs_to_many :demographic

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:user, :editor, :admin]

  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def editor?
    Rails.logger.debug "User role comparison #{User.roles[self.role]} >= #{User.roles[:editor]}"
    User.roles[self.role] >= User.roles[:editor]
  end

  def admin?
    User.roles[self.role] == User.roles[:admin]
  end
end
