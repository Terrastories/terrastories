require 'rails_helper'

RSpec.describe Story, type: :model do
  it 'can be initialized' do
    expect(create(:story)).to be_a(Story)
  end
end
