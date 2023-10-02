require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "validates content type size" do
      is_expected.to validate_content_type_of(:photo).allowing(
        'image/png',
        'image/jpg',
        'image/jpeg',
      )
    end

    it "validates file size" do
      is_expected.to validate_size_of(:photo).less_than_or_equal_to(5.megabytes)
    end
  end

  describe 'ensuring a user always has a role set' do
    it 'has the correct default role as new user' do
      user = FactoryBot.create(:user)
      expect(user.role).to eq('viewer')
    end

    it 'does not change a user with an already set role back to the default role' do
      user = FactoryBot.create(:user, role: 'editor')
      expect(user.role).to eq('editor')
    end

    it "gives user a role on new record" do
      user = FactoryBot.build(:user)
      expect(user.role).to eq('viewer')
    end
  end

  describe "community" do
    it "allows user to exist without a community" do
      user = FactoryBot.build(:user, community: nil)

      expect(user).to be_valid
    end

    it "nullify's community relationship when community is destroyed" do
      community = FactoryBot.create(:community)
      user = FactoryBot.create(:user, community: community)

      expect(user.community).to eq(community)

      community.destroy

      expect(user.reload.community_id).to be_nil
    end
  end
end
