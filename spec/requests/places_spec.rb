require "rails_helper"

RSpec.describe "Places", type: :request do
  before :each do
    @rfg2018 = create(:place)
  end

  describe "GET new" do
    it 'should create a new Place instance and assign it to @place' do
      get "/en/places/new"

      expect(assigns(:place)).to be_a_new(Place)
    end
  end

  describe "GET edit" do
    context 'with existing :id passed' do
      it 'should get the place and assign it to @place' do
        get "/en/places/#{@rfg2018.id}/edit"

        expect(assigns(:place)).to eq(@rfg2018)
      end
    end
  end

  describe "GET show" do
    it 'should get the place and assign it to @place' do
      get "/en/places/#{@rfg2018.id}"

      expect(assigns(:place)).to eq(@rfg2018)
    end
  end

  describe "POST create" do
    it 'should redirect to :show' do
      post "/en/places", params: {
        place: {
          name: "Georgetown University",
          type_of_place: "college campus",
          long: -77.073168,
          lat: 38.906302,
          region: 'Washington DC'
        }
      }

      expect(response).to redirect_to(place_path(assigns(:place)))
    end
  end

  describe "PUT update" do
    before :each do
      put "/en/places/#{@rfg2018.id}", params: {
        id: @rfg2018,
        place: {
          name: "New name"
        }
      }
    end

    it 'should get the place and assign it to @place' do
      expect(assigns(:place)).to eq(@rfg2018)
    end

    it 'should redirect to :show' do
      expect(response).to redirect_to(place_path(assigns(:place)))
    end
  end
end
