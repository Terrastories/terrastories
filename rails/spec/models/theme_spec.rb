require 'rails_helper'

RSpec.describe Theme, type: :model do
  let(:theme) {FactoryBot.create(:theme, community: FactoryBot.create(:community))}

  it "raises an error with invalid center latitude" do
    expect do
      theme.center_lat = 100
      theme.save!
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Latitude value should be between -90 and 90")
  end

  it "sets default map values from model if none are provided on creation" do
    expect(theme.zoom).to eq 2
  end

  it "updates map values as appropriate" do
    expect do
      theme.zoom = 7
    end.to change(theme, :zoom).from(2).to(7)
  end

  it "returns map points as an array of longitude and latitude" do
    expect(theme.center).to be_an_instance_of Array
    expect(theme.center).to eq [0, 15]
    expect(theme.sw_boundary).to eq nil # was [-180, -85]
    expect(theme.ne_boundary).to eq nil # was [180, 85]
  end
end
