require "rails_helper"

RSpec.describe "Home", :type => :request do
  it "opens the home index without signing in" do
    get "/"

    expect(response.status).to equal(200)
    expect(response.body).to include("Welcome")
    expect(response.body).to include("Are you an Admin?")
  end
end