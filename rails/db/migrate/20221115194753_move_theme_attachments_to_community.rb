class MoveThemeAttachmentsToCommunity < ActiveRecord::Migration[6.1]
  def up
    ActiveStorage::Attachment.where(record_type: "Theme").find_each do |attachment|
      # Associated record could be gone without having purged attachment
      next if attachment.record.nil?
      community_id = attachment.record.community_id
      attachment.update(
        record_type: "Community",
        record_id: community_id
      )
    end
  end

  def down
    ActiveStorage::Attachment.where(record_type: "Community").find_each do |attachment|
      # Associated record could be gone without having purged attachment
      next if attachment.record.nil?
      theme_id = attachment.record.theme.id
      attachment.update(
        record_type: "Theme",
        record_id: theme_id
      )
    end
  end
end
