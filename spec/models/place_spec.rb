require 'rails_helper'

RSpec.describe Place, type: :model do
  it_behaves_like 'importable', 'places.csv'
end
