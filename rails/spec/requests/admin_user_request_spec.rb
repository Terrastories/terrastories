require 'rails_helper'

RSpec.describe "SuperAdmin user request", type: :request do
  describe "GET edit" do
    context "with a super admin privileges" do
      let(:super_admin) { FactoryBot.create(:user, role: 100, super_admin: true) }
      let(:user) { FactoryBot.create(:user, role: 1) }

      before do
        login_as super_admin 
      end

      it "should return the user of the specified route" do
        get "/admin/users/#{user.id}/edit" 

        p response
        expect(response).to have_http_status(:success)
      end
    end
  end
end
