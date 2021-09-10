require 'rails_helper'

RSpec.describe Theme, type: :model do
  let(:theme) {Theme.new()}
  it "can add sponsor logo" do
    theme.sponsor_logos.attach(io: File.open("./spec/fixtures/media/terrastories.png"), filename: 'file.pdf')
    expect(theme).to be_valid
  end

  it "raises an error with invalid center latitude" do
    expect do
      theme.center_lat = 100
      theme.save!
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Center lat value should be between -90 and 90")
  end

  it "sets default map values from model if none are provided on creation" do
    expect(theme.zoom).to eq 3.5
  end

  it "updates map values as appropriate" do
    expect do
      theme.zoom = 7
    end.to change(theme, :zoom).from(3.5).to(7)
  end

  it "returns map points as an array of longitude and latitude" do
    expect(theme.center).to be_an_instance_of Array
    expect(theme.center).to eq [-108, 38.5]
    expect(theme.sw_boundary).to eq [-180, -85]
    expect(theme.ne_boundary).to eq [180, 85]
  end
end
