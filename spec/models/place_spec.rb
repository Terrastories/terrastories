require 'rails_helper'
require 'csv'


RSpec.describe Place, type: :model do


  describe 'associations' do
    it { should have_many :interview_stories }
    it { should have_and_belongs_to_many :stories }
  end

  describe 'import_csv' do
  end

  describe '#photo_format' do
    it 'should have a prefix' do
      binding.pry
    end
  end

  describe 'photo_url' do
  end

  describe 'point_geojson' do
  end

  pending "add some examples to (or delete) #{__FILE__}"
end
