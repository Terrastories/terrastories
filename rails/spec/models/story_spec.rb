require 'rails_helper'

RSpec.describe Story, type: :model do

  
  let(:place) { Place.create!(name: "Place", type_of_place: "placetype")}
  let(:speaker) { Speaker.create!(name: 'Speaker Name', birthdate: Date.ordinal(1992), birthplace: place, community: 'Speaker Community') }
  let(:story) { Story.create!(title: 'The Mad Hatter', desc: "We're all mad here!", permission_level: 0, interview_location: place, interviewer: speaker )}

  describe "initialize model" do
    it 'can be initialized' do
   
      expect(create(story)).to be_a(Story)
    end
  end

end