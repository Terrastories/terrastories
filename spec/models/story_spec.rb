require 'rails_helper'

RSpec.describe Story, type: :model do
  it_behaves_like 'importable', 'stories.csv'
end
