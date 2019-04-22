require 'rails_helper'

RSpec.describe Place, type: :model do
  it 'can be initialized' do
    expect(create(:place)).to be_a(Place)
  end
end
