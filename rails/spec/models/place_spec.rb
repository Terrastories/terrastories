require 'rails_helper'

RSpec.describe Place, type: :model do

  let(:place) { Place.create!(name: "Place", type_of_place: "placetype")}

  describe "initialize" do
    it 'can be initialized' do
      expect(create(:place)).to be_a(Place)
    end
  end

  describe "attributes" do
    it "responds to attributes name and placetype" do
      expect(place).to have_attributes(name: "Place", type_of_place: "placetype")
    end
  end


end
