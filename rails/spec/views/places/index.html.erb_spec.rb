require 'rails_helper'

RSpec.describe "places/index", type: :view do
  before(:each) do
    assign(:places, [
      Place.create!(),
      Place.create!()
    ])
  end

  it "renders a list of places" do
    render
  end
end
