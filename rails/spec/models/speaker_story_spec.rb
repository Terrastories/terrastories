require 'rails_helper'

RSpec.describe SpeakerStory, type: :model do
  it 'belongs to speaker' do
    association = described_class.reflect_on_association(:speaker)

    expect(association.macro).to eq(:belongs_to)
  end

  it 'belongs to story' do
    association = described_class.reflect_on_association(:story)

    expect(association.macro).to eq(:belongs_to)
  end
end
