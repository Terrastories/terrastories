require 'rails_helper'

RSpec.describe "SuperAdmin user request", type: :request do
  describe "GET edit" do
    context "with a super admin privileges" do
      let(:super_admin) { FactoryBot.create(:user, role: 100, super_admin: true) }
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 2) }

      before do
        login_as super_admin 
      end

      it "should return success if the user is an admin" do
        get "/admin/users/#{user.id}/edit" 
        expect(response).to have_http_status(200)
      end
    end

    context "without a super admin privileges" do
      let(:other_user) { FactoryBot.create(:user, role: 1) }
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 1) }

      before do
        login_as other_user 
      end

      it "should raise an error when the user tries to access super admin" do
        assert_raises ActionController::RoutingError do
         get "/admin/users/#{user.id}/edit" 
        end
      end

    end
  end

  describe "PUT update"  do
    context "with a super admin privileges" do
      let(:super_admin) { FactoryBot.create(:user, role: 100, super_admin: true) }
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 2) }

      before do
        login_as super_admin 
      end
      it "should return success if the user is an admin" do
        put "/admin/users/#{user.id}", :params => {:user => { password: "securePassword" } }

        expect(response).to have_http_status(302)
        expect(flash[:notice]).to match('User successfully updated')
      end
    end

    context "without a super admin privileges" do
      let(:other_user) { FactoryBot.create(:user, role: 1) }
      let(:user) { FactoryBot.create(:user, email: "user@mail.co", username: "user_name", role: 1) }

      before do
        login_as other_user 
      end

      it "should raise an error when the user tries to access super admin" do
        assert_raises ActionController::RoutingError do
         put "/admin/users/#{user.id}/edit" 
        end
      end

    end
  end
end
