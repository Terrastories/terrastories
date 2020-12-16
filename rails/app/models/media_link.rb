class MediaLink < ApplicationRecord
    belongs_to :story
end

# == Schema Information
#
# Table name: media_links
#
#  id         :bigint           not null, primary key
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  story_id   :bigint
#
# Indexes
#
#  index_media_links_on_story_id  (story_id)
#
