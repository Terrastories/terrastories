require 'rails_helper'

RSpec.describe "places/show", type: :view do
  before(:each) do
    @place = assign(:place, Place.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
