require 'rails_helper'

RSpec.describe Speaker, type: :model do

  let(:place) { Place.create!(name: "Place", type_of_place: "placetype")}
  let(:speaker) { Speaker.create!(name: 'Speaker Name', birthdate: Date.ordinal(1992), birthplace: place, community: 'Speaker Community') }
    
    describe "attributes" do
      it "responds to name birthplace birthyear and community" do
        expect(speaker).to have_attributes(name: 'Speaker Name', birthdate: Date.ordinal(1992), birthplace: place, community: 'Speaker Community')
      end
    end

  describe "initialize model" do
    it 'can be initialized' do
      expect(create(:speaker)).to be_a(Speaker)
    end
  end


end
