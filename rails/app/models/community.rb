class Community < ApplicationRecord
  has_one_attached :display_image
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

  validates :slug, presence: true, if: -> { self.public }

  FILTERABLE_ATTRIBUTES = %w(places region type_of_place speakers topic language speaker_community)

  # override(slug)
  # ensure slug is set using downcased and underscored name
  # ensure slug value is unique by appending idx when necessary
  def slug=(value)
    # if not public and value is some form of unset, allow default setter
    return super(value) if value.blank? && !self.public

    value = self.name.downcase.strip.gsub(" ", "_") if value.blank?
    if Community.where.not(id: self).exists?(slug: value)
      index = value.split("_").last.to_i
      loop do
        index+=1
        value = [value, index].join("_")
        break unless Community.exists?(slug: value)
      end
    end
    super(value)
  end

  def filters(permission_level = :anonymous)
    [
      places.joins(:stories).where(stories: {permission_level: permission_level}).distinct.map { |p| {label: p.name, value: p.id, category: :places } },
      places.joins(:stories).where(stories: {permission_level: permission_level}).pluck(:region).uniq.reject(&:blank?).map { |r| {label: r, value: r, category: :region } },
      places.joins(:stories).where(stories: {permission_level: permission_level}).pluck(:type_of_place).uniq.reject(&:blank?).map { |r| {label: r, value: r, category: :type_of_place } },
      stories.where(stories: {permission_level: permission_level}).pluck(:topic).uniq.reject(&:blank?).map { |r| {label: r, value: r, category: :topic } },
      stories.where(stories: {permission_level: permission_level}).pluck(:language).uniq.reject(&:blank?).map { |r| {label: r, value: r, category: :language } },
      speakers.joins(:stories).where(stories: {permission_level: permission_level}).distinct.map { |s| {value: s.id, label: s.name, category: :speakers } },
      speakers.joins(:stories).where(stories: {permission_level: permission_level}).pluck(:speaker_community).uniq.reject(&:blank?).map { |r| {label: r, value: r, category: :speaker_community } }
    ].flatten
  end

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
#  id          :bigint           not null, primary key
#  beta        :boolean          default(FALSE)
#  country     :string
#  description :text
#  locale      :string
#  name        :string
#  public      :boolean          default(FALSE), not null
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_communities_on_public  (public)
#  index_communities_on_slug    (slug)
#
