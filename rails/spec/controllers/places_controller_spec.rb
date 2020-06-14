require 'rails_helper'

RSpec.describe PlacesController, type: :controller do
  before :each do
    @rfg2018 = create(:place)
  end

  describe "GET index" do
    subject { get :index }

    it "should return 200 status code" do
      expect(subject).to have_http_status(200)
    end
  end

  describe "GET show" do
    subject { get :show, params: { id: @rfg2018 } }

    it "should return 200 status code" do
      expect(subject).to have_http_status(200)
    end
  end

  describe "GET new" do
    subject { get :new }

    it "should return 200 status code" do
      expect(subject).to have_http_status(200)
    end
  end

  describe "GET edit" do
    subject { get :edit, params: { id: @rfg2018 } }

    it "should return 200 status code" do
      expect(subject).to have_http_status(200)
    end
  end

  describe "POST create" do
    subject {
      post :create,
           params: {
             place: {
               name: "Georgetown University",
               type_of_place: "college campus",
               long: -77.073168,
               lat: 38.906302,
               region: 'Washington DC'
             }
           }
    }

    it "should create a new Place record" do
      expect { subject }.to change { Place.count }.by(1)
    end

    it "should return 302 status code" do
      expect(subject).to have_http_status(302)
    end
  end

  describe "PUT update" do
    subject {
      put :update,
          params: {
            id: @rfg2018,
            place: {
              name: "New name"
            }
          }
    }

    it "should update a given Place record" do
      subject

      @rfg2018.reload

      expect(@rfg2018.name).to eq("New name")
    end

    it "should return 302 status code" do
      expect(subject).to have_http_status(302)
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, params: { id: @rfg2018 } }

    it "should delete a given Place record" do
      expect { subject }.to change { Place.count }.by(-1)
    end

    it "should return 302 status code" do
      expect(subject).to have_http_status(302)
    end

    it "should redirect to places_url" do
      subject
      expect(subject).to redirect_to(places_url)
    end
  end
end
