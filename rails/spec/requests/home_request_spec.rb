require 'rails_helper'

RSpec.describe "Home request", type: :request do
  describe "GET home" do
    context "a logged in user" do
      let(:user) { FactoryBot.create(:user) }
      before do
        login_as user
      end
      it "renders the home template" do
        get "/home"

        expect(response).to have_http_status(:success)
      end
    end
    context "an unauthenticated user" do
      it "forwards to the login page" do
        get "/home"

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
