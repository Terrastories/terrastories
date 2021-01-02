class Curriculum < ApplicationRecord
    belongs_to :user
    has_many :curriculum_stories
    has_many :stories, through: :curriculum_stories
    accepts_nested_attributes_for :curriculum_stories

    
end

# == Schema Information
#
# Table name: curriculums
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_curriculums_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
