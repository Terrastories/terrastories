require 'rails_helper'

RSpec.describe Point, type: :model do
  it 'can be initialized' do
    expect(create(:point)).to be_a(Point)
  end
end
