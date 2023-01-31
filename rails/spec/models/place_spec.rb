require 'rails_helper'

RSpec.describe Place, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many :stories }
    it { should have_many :interview_stories }
  end

  describe 'export_sample_csv' do
    it 'downloads a csv' do
      expect(described_class.export_sample_csv).to eq("name,type_of_place,description,region,long,lat,media\n")
    end
  end
end
