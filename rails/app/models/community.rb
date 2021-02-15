class Community < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :places, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :speakers, dependent: :destroy

  belongs_to :theme, autosave: true, dependent: :destroy

  after_initialize :create_theme, if: -> { theme.nil? }

  accepts_nested_attributes_for :users, limit: 1

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
