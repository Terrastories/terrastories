require 'rails_helper'

RSpec.describe MediaLink, type: :model do
  describe "associations" do
    it { should belong_to :story }
  end
end
