require 'rails_helper'

RSpec.describe Speaker, type: :model do
  it 'can be initialized' do
    expect(create(:speaker)).to be_a(Speaker)
  end
end
