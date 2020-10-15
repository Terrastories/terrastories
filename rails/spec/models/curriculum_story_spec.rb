require 'rails_helper'

RSpec.describe CurriculumStory, type: :model do
  describe 'associations' do
    it { should belong_to(:curriculum) }
    it { should belong_to(:story) }
    it { should accept_nested_attributes_for(:story) }
  end
end
