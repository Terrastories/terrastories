require 'rails_helper'

RSpec.describe "user request", type: :request do
  describe "GET edit" do
    context "with a super admin privileges" do
      let(:super_admin) { FactoryBot.create(:user, role: 100, super_admin: true) }
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 1) }

      before do
        login_as super_admin 
      end

      it "should return success" do
        get "/member/users/#{user.id}/edit" 
        expect(response).to have_http_status(200)
      end
    end

    context "with local admin privileges in the same community" do
      let(:community) { FactoryBot.create(:community) }
      let(:admin) { FactoryBot.create(:user, role: 2, community_id: community.id) }
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 1, community_id: community.id) }

      before do
        login_as admin 
      end

      it "should return success if the admin is in the same community" do
        get "/member/users/#{user.id}/edit" 
        expect(response).to have_http_status(200)
      end

    end

    context "with local admin privileges not in the same community" do
      let(:community) { FactoryBot.create(:community) }
      let(:admin) { FactoryBot.create(:user, role: 2) }
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 1, community_id: community.id) }

      before do
        login_as admin 
      end

      it "should redirect if admin is not in the same community" do 
        get "/member/users/#{user.id}/edit" 
        expect(response).to have_http_status(302)
      end
    end

    context "changing user's own settings" do
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 1) }

      before do
        login_as user 
      end

      it "should return success if it's the users own profile " do
        get "/member/users/#{user.id}/edit" 
        expect(response).to have_http_status(200)
      end

    end

    context "changing another user's settings" do
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 1) }
      let(:other_user) { FactoryBot.create(:user, email: "other_user@mail.co", username: "other_user_name", role: 1) }

      before do
        login_as user 
      end

      it "should redirect if it's not the current_users profile" do
        get "/member/users/#{other_user.id}/edit" 
        expect(response).to have_http_status(302)
      end

    end
  end

  describe "PUT update" do
    context "with a super admin privileges" do
      let(:super_admin) { FactoryBot.create(:user, role: 100, super_admin: true) }
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 1) }

      before do
        login_as super_admin 
      end

      it "should return success" do
        get "/member/users/#{user.id}/edit" 
        expect(response).to have_http_status(200)
      end
    end

    context "with local admin privileges in the same community" do
      let(:community) { FactoryBot.create(:community) }
      let(:admin) { FactoryBot.create(:user, role: 2, community_id: community.id) }
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 1, community_id: community.id) }

      before do
        login_as admin 
      end

      it "should return success if the admin is in the same community" do
        get "/member/users/#{user.id}/edit" 
        expect(response).to have_http_status(200)
      end

    end

    context "with local admin privileges not in the same community" do
      let(:community) { FactoryBot.create(:community) }
      let(:admin) { FactoryBot.create(:user, role: 2) }
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 1, community_id: community.id) }

      before do
        login_as admin 
      end

      it "should redirect if admin is not in the same community" do 
        get "/member/users/#{user.id}/edit" 
        expect(response).to have_http_status(302)
      end
    end

    context "changing user's own settings" do
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 1) }

      before do
        login_as user 
      end

      it "should return success if it's the users own profile " do
        get "/member/users/#{user.id}/edit" 
        expect(response).to have_http_status(200)
      end

    end

    context "changing another user's settings" do
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 1) }
      let(:other_user) { FactoryBot.create(:user, email: "other_user@mail.co", username: "other_user_name", role: 1) }

      before do
        login_as user 
      end

      it "should redirect if it's not the current_users profile" do
        get "/member/users/#{other_user.id}/edit" 
        expect(response).to have_http_status(302)
      end
    end
  end
end
