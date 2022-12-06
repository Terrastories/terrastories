class Community < ApplicationRecord
  has_one_attached :background_img
  has_many_attached :sponsor_logos

  has_many :users, dependent: :nullify
  has_many :places, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :speakers, dependent: :destroy

  has_one :theme, dependent: :destroy

  after_create :create_theme, if: -> { theme.nil? }

  accepts_nested_attributes_for :users, limit: 1

  validates :background_img, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }
  validates :sponsor_logos, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..5.megabytes }

  # Flipper Feature Groups
  # See config/initializers/flipper.rb to view registered groups
  def feature_groups
    Flipper.groups.each_with_object([]) do |group, arr|
      arr << group.name if self.respond_to?(group.name) ? self.send(group.name) : self.send("#{group.name}_group?")
    end
  end

  # Flipper `developers` group conditions
  def developers_group?
    name.match?("Ruby for Good")
  end
end

# == Schema Information
#
# Table name: communities
#
#  id         :bigint           not null, primary key
#  beta       :boolean          default(FALSE)
#  country    :string
#  locale     :string
#  name       :string
#  public     :boolean          default(FALSE), not null
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_communities_on_public  (public)
#  index_communities_on_slug    (slug)
#
