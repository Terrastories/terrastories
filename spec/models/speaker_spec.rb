require 'rails_helper'

RSpec.describe Speaker, type: :model do

  it_behaves_like 'importable', 'speakers.csv'

  let(:speaker) { Speaker.new(name: "Oliver Twist", birthdate: DateTime.new(1992))  }

  describe "attributes" do
    it "has name and birthdate attributes" do
      expect(speaker).to have_attributes(name: "Oliver Twist", birthdate: DateTime.new(1992))
    end
  end

end
