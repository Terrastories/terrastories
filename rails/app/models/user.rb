class User < ApplicationRecord
  has_secure_password

  attr_accessor :login

  belongs_to :community, optional: true, touch: true
  has_one_attached :photo

  validates :photo, content_type: [:png, :jpeg], size: { less_than_or_equal_to: 5.megabytes }
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

  def update_tracked_fields(request)
    old_current, new_current = self.current_sign_in_at, Time.now.utc
    self.last_sign_in_at     = old_current || new_current
    self.current_sign_in_at  = new_current

    old_current, new_current = self.current_sign_in_ip, request.remote_ip
    self.last_sign_in_ip     = old_current || new_current
    self.current_sign_in_ip  = new_current

    self.sign_in_count ||= 0
    self.sign_in_count += 1
  end

  protected

  # :password_digest is required for has_secure_password;
  # mapped to :encrypted_password since that's what Devise used previously.
  alias_attribute :password_digest, :encrypted_password
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
#  index_users_on_email                 (email)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
