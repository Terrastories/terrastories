require 'rails_helper'

RSpec.describe Place, type: :model do
  describe 'Associations' do
    it { is_expected.to have_one(:photo_attachment).class_name('ActiveStorage::Attachment') }
    it { is_expected.to have_many(:interview_stories).class_name('Story').with_primary_key('interview_location_id') }
    it { is_expected.to have_and_belong_to_many(:stories) }
  end
end
