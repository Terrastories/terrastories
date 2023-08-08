class MoveStoryMediaAttachmentsToModel < ActiveRecord::Migration[6.1]
  def up
    ActiveStorage::Attachment.where(record_type: "Story").find_each do |att|
      story = Story.find_by(id: att.record_id)
      next if story.nil?

      media = Medium.new(story_id: att.record_id)
      media.save!(:validate => false)

      att.update(record_type: "Medium", record_id: media.id)
    end
  end

  def down
    ActiveStorage::Attachment.where(record_type: "Medium").find_each do |att|
      att.update(record_type: "Story", record_id: att.record.story_id)
    end
    Medium.delete_all
  end
end
