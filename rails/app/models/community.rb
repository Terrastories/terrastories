class Community < ApplicationRecord
  has_many :users
  has_many :places
  has_many :stories

  belongs_to :theme, autosave: true

  after_initialize :create_theme

  def create_theme
    build_theme
  end
end

# == Schema Information
#
# Table name: communities
#
#  id         :bigint           not null, primary key
#  country    :string
#  locale     :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  theme_id   :integer
#
