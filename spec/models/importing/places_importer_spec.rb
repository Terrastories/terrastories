require 'rails_helper'

RSpec.describe Importing::PlacesImporter, type: :model do
  let(:headers) { %w(Place_name Type_of_place Description Region lat long photo) }

  let(:data) do
    CSV.generate(headers: true) do |csv|
      csv << headers
      csv << attributes
    end
  end

  let(:import) { Place.import(data) }

  context 'general' do
    let(:attributes) do
      ['Lorem Ipsum', 'dang', 'Description', 'Iiba', 4.340923, -55.787912, nil]
    end

    it 'imports places from file' do
      expect { Place.import(data) }.to change { Place.count }.by(1)

      place = Place.find_by(name: attributes[0])

      expect(place).to_not be_nil
      expect(place.type_of_place).to eq(attributes[1])
      expect(place.description).to eq(attributes[2])
      expect(place.region).to eq(attributes[3])
      expect(place.lat).to eq(attributes[4])
      expect(place.long).to eq(attributes[5])
    end
  end

  context 'with photo' do
    let(:attributes) do
      ['Lorem Ipsum', 'dang', 'Description', 'Iiba', 4.3409234, -55.7879123, 'test/test.png']
    end

    it 'attaches photo' do
      import

      place = Place.find_by(name: attributes[0])
      expect(place.photo.attached?).to be true
    end
  end

  context 'without photo' do
    let(:attributes) do
      ['Lorem Ipsum', 'dang', 'Description', 'Iiba', 4.3409234, -55.7879123, nil]
    end

    it 'does not attach photo' do
      import

      place = Place.find_by(name: attributes[0])
      expect(place.photo.attached?).to be false
    end
  end
end
