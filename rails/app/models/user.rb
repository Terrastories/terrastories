class User < ApplicationRecord
  # Include default devise modules. Others available are: :registerable,
  # :recoverable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable
  attr_accessor :login

  belongs_to :community, optional: true
  has_one_attached :photo

  # Username is required for logging in with Devise. Email is optional.
  # Remove email_required? override if username changes to optional.
  validates :username, uniqueness: true, presence: true, format: {without: /\s/, message: :invalid_username_format}

  enum role: {
    member: 0, # previously user; can view restricted stories
    editor: 1,
    admin: 2,
    viewer: 3, # can only view public/anonymous stories
    super_admin: 100 # super admin
  }

  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :viewer
  end

  def display_name
    name.presence || username
  end

  # Override Devise authentication to allow lookup via username or email
  def self.find_first_by_auth_conditions(tainted_conditions)
    if (login = tainted_conditions.delete(:login))
      where(username: login).or(where(email: login)).first
    else
      super
    end
  end

  protected

  # Override Devise Validatable: email is not required (username is)
  def email_required?
    false
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer
#  sign_in_count          :integer          default(0), not null
#  super_admin            :boolean          default(FALSE), not null
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  community_id           :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
