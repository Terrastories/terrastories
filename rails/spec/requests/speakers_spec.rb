require "rails_helper"

RSpec.describe "Speakers", type: :request do
  before :each do
    @miranda = create(:speaker)
  end

  describe "GET index" do
    it 'should get all speakers and assign them to @speakers' do
      Array.new(3) { create(:speaker) }

      get "/en/speakers"

      expect(assigns(:speakers)).to eq(Speaker.all)
    end
  end

  describe "GET edit" do
    context 'with existing :id passed' do
      it 'should get the speaker and assign it to @speaker' do
        get "/en/speakers/#{@miranda.id}/edit"

        expect(assigns(:speaker)).to eq(@miranda)
      end
    end

    context 'with non-existing :id passed' do
      it 'should create a new Speaker instance and assign it to @speaker' do
        get "/en/speakers/-1/edit"

        expect(assigns(:speaker)).to be_a_new(Speaker)
      end
    end
  end

  describe "GET new" do
    it 'should create a new Speaker instance and assign it to @speaker' do
      get "/en/speakers/new"

      expect(assigns(:speaker)).to be_a_new(Speaker)
    end
  end

  describe "GET show" do
    it 'should get the speaker and assign it to @speaker' do
      get "/en/speakers/#{@miranda.id}"

      expect(assigns(:speaker)).to eq(@miranda)
    end
  end

  describe "POST create" do
    it 'should redirect to :show' do
      post "/en/speakers", params: {
        speaker: {
          name: "Jon Snow"
        }
      }

      expect(response).to redirect_to(speaker_path(assigns(:speaker)))
    end
  end

  describe "PUT update" do
    before :each do
      put "/en/speakers/#{@miranda.id}", params: {
        id: @miranda,
        speaker: {
          name: "New Name"
        }
      }
    end

    it 'should get the speaker and assign it to @speaker' do
      expect(assigns(:speaker)).to eq(@miranda)
    end

    it 'should redirect to :show' do
      expect(response).to redirect_to(speaker_path(assigns(:speaker)))
    end
  end
end
