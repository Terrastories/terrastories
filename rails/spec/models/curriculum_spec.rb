require 'rails_helper'

RSpec.describe Curriculum, type: :model do
  describe 'associations' do
    it { should belong_to :user}
    it { should have_many :curriculum_stories}
    it { should have_many :stories }
  end
end
