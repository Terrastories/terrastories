require 'rails_helper'

RSpec.describe SpeakersController, type: :controller do
  before :each do
    @miranda = create(:speaker)
  end

  describe "GET index" do
    it 'should return 200 status code' do
      get :index

      expect(response).to have_http_status(200)
    end
  end

  describe "GET edit" do
    it 'should return 200 status code' do
      get :edit, params: { id: @miranda }

      expect(response).to have_http_status(200)
    end
  end

  describe "GET new" do
    subject { get :new }

    it 'should return 200 status code' do
      expect(subject).to have_http_status(200)
    end
  end

  describe "GET show" do
    subject { get :show, params: { id: @miranda } }

    it 'should return 200 status code' do
      expect(subject).to have_http_status(200)
    end
  end

  describe "POST create" do
    subject {
      post :create,
           params: {
             speaker: {
               name: "Jon Snow"
             }
           }
    }

    it 'should create a new Speaker record' do
      expect { subject }.to change { Speaker.count }.by(1)
    end

    it 'should return 302 status code and redirect to :show' do
      expect(subject).to have_http_status(302)
    end
  end

  describe "PUT update" do
    subject {
      put :update,
          params: {
            id: @miranda,
            speaker: {
              name: "New Name"
            }
          }
    }

    it 'should update a given Speaker record' do
      subject

      @miranda.reload

      expect(@miranda.name).to eq("New Name")
    end

    it 'should return 302 status code and redirect to :show' do
      expect(subject).to have_http_status(302)
    end
  end
end
