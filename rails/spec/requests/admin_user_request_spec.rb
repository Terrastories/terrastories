require 'rails_helper'

RSpec.describe "SuperAdmin user request", type: :request do
  describe "GET home" do
    context "a logged in user" do
      let(:user) { FactoryBot.create(:user, role: 100, super_admin: true) }
      before do
        login_as user
      end

      it "test" do
        p user
        get "/admin/users/#{user.id}/edit" 

        expect(response).to have_http_status(:success)
      end
    end
  end
end
