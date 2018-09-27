require 'rails_helper'

RSpec.describe "places/new", type: :view do
  before(:each) do
    assign(:place, Place.new())
  end

  it "renders new place form" do
    render

    assert_select "form[action=?][method=?]", places_path, "post" do
    end
  end
end
