require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  before :each do
    @rfg2018 = create(:place)
    @miranda = create(:speaker)
    @rudo_story = create(:story, :with_speakers)
  end

  describe "GET index" do
  end

  describe "GET edit" do
    it 'should return 200 status code' do
      get :edit, params: { id: @rudo_story }

      expect(response.status).to eq(200)
    end
  end

  describe "GET new" do
    subject { get :new }

    it 'should return 200 status code' do
      expect(subject).to have_http_status(200)
    end
  end

  describe "GET show" do
    subject { get :show, params: { id: @rudo_story } }

    it 'should return 200 status code' do
      expect(subject).to have_http_status(200)
    end
  end

  describe "POST create" do
    subject {
      post :create,
           params: {
             story: {
               title: "Story title",
               desc: "Story description",
               permission_level: "anonymous",
               interview_location_id: @rfg2018,
               interviewer_id: @miranda,
               speaker_ids: [ @miranda ]
             }
           }
    }

    it 'should create a new Story record' do
      expect { subject }.to change { Story.count }.by(1)
    end

    it 'should return 302 status code and redirect to :show' do
      expect(subject).to have_http_status(302)
    end
  end

  describe "PUT update" do
    subject {
      put :update,
          params: {
            id: @rudo_story,
            story: {
              title: "Story title", desc: "Story description", interview_location_id: @rfg2018, interviewer_id: @miranda
            }
          }
    }

    it 'should update a given Story record' do
      subject

      @rudo_story.reload

      expect(@rudo_story.title).to eq("Story title")
      expect(@rudo_story.desc).to eq("Story description")
      expect(@rudo_story.interview_location_id).to eq(@rfg2018.id)
      expect(@rudo_story.interviewer_id).to eq(@miranda.id)
    end

    it 'should return 302 status code and redirect to :show' do
      expect(subject).to have_http_status(302)
    end
  end
end
