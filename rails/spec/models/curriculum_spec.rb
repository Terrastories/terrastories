require 'rails_helper'

RSpec.describe Curriculum, type: :model do
  describe 'associations' do
    it { should belong_to :user }
    it { should have_many :curriculum_stories }
    it { should have_many :stories }
    it { should accept_nested_attributes_for(:curriculum_stories) }
  end
end
