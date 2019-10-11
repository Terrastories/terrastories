require 'rails_helper'
require 'csv'

RSpec.describe Importing::SpeakersImporter, type: :model do
  let(:headers) { %w(Speaker_name Birth_year Born_where Photo) }

  let(:data) do
    CSV.generate(headers: true) do |csv|
      csv << headers
      csv << attributes
    end
  end

  let(:import) { Speaker.import(data) }

  context 'general' do
    let(:attributes) { ['Mary Frank', 1930, 'Suki', nil] }

    it 'imports speakers from file' do

      expect { import }.to change { Speaker.count }.by(1)

      speaker = Speaker.find_by(name: attributes[0])

      expect(speaker).to_not be_nil
      expect(speaker.birthplace).to eq(Place.find_by(name: attributes[2]))
      expect(speaker.birthdate).to eq(Date.new(attributes[1]))
    end
  end

  context 'without photo' do
    let(:attributes) { ['Mary Frank', 1930, 'Suki', nil] }

    it 'does not attach photo' do
      import
      speaker = Speaker.find_by(name: attributes[0])
      expect(speaker.photo.attached?).to be false
    end
  end

  context 'with photo' do
    let(:attributes) { ['Mary Frank', 1930, 'Suki', 'test/test.png'] }

    it 'attaches photo' do
      import
      speaker = Speaker.find_by(name: attributes[0])
      expect(speaker.photo.attached?).to be true
    end

  end

  context 'with unknown birth year' do
    let(:attributes) { ['Mary Frank', 'unknown', 'Suki', nil] }

    it 'does not set birthdate' do
      import
      speaker = Speaker.find_by(name: attributes[0])
      expect(speaker.birthdate).to be_nil
    end
  end

  context 'wtihout birth year' do
    let(:attributes) { ['Mary Frank', nil, 'Suki', 'speaker.png'] }

    it 'does not set birthdate' do
      import
      speaker = Speaker.find_by(name: attributes[0])
      expect(speaker.birthdate).to be_nil
    end
  end

  context 'with birth year' do
    let(:attributes) { ['Mary Frank', 1930, 'Suki', 'speaker.png'] }

    it 'sets birthdate' do
      import
      speaker = Speaker.find_by(name: attributes[0])
      expect(speaker.birthdate).to eq(Date.new(1930))
    end
  end

  context 'with birth place' do
    let(:attributes) { ['Mary Frank', 1930, 'Suki', nil] }

    it 'creates new place' do
      expect { import }.to change { Place.count }.by(1)

      speaker = Speaker.find_by(name: attributes[0])
      place = Place.find_by(name: attributes[2])
      expect(speaker.birthplace).to eq(place)
    end
  end

  context 'with unknown birth place' do
    let(:attributes) { ['Mary Frank', 1930, 'unknown', nil] }

    it 'creates no new place' do
      expect { import }.to_not change { Place.count }

      speaker = Speaker.find_by(name: attributes[0])
      expect(speaker.birthplace).to be_nil
    end
  end

  context 'without birth place' do
    let(:attributes) { ['Mary Frank', 1930, nil, nil] }

    it 'creates no new place' do
      expect { import }.to_not change { Place.count }

      speaker = Speaker.find_by(name: attributes[0])
      expect(speaker.birthplace).to be_nil
    end
  end
end
