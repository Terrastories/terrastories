# This model is backed by Flipper
class FlipperFeature < ApplicationRecord
  validates :key, presence: true, format: {with: /\A[a-zA-Z\_]+\z/}

  def enabled?
    Flipper.enabled?(key)
  end

  def enable(actor: nil, group: nil)
    if actor
      feature.enable_actor(actor)
    elsif group
      feature.enable_group(group)
    else
      feature.enable
    end
    touch
  end

  def disable(actor: nil, group: nil)
    if actor
      feature.disable_actor(actor)
    elsif group
      feature.disable_group(group)
    else
      feature.disable
    end
    touch
  end

  def actors
    actors_value.map do |actor|
      klass, id = actor.split(";")
      klass.constantize.find_by(id: id)
    end
  end

  def all_groups
    feature.enabled_groups + feature.disabled_groups
  end

  def feature
    Flipper[key]
  end

  def state_status
    case feature.state
    when :off
      "Disabled"
    else
      "Enabled"
    end
  end

  delegate :remove, :enabled_gate_names, :actors_value, :groups, :state, to: :feature
end

# == Schema Information
#
# Table name: flipper_features
#
#  id          :bigint           not null, primary key
#  description :text
#  key         :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_flipper_features_on_key  (key) UNIQUE
#
