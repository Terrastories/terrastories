require "rails_helper"

RSpec.describe "Stories", type: :request do
  before :each do
    @rfg2018 = create(:place)
    @miranda = create(:speaker)
    @rudo_story = create(:story)
  end

  describe "GET edit" do
    context 'with existing :id passed' do
      it 'should get the story and assign it to @story' do
        get "/en/stories/#{@rudo_story.id}/edit"

        expect(assigns(:story)).to eq(@rudo_story)
      end
    end

    context 'with non-existing :id passed' do
      it 'should create a new Story instance and assign it to @story' do
        get "/en/stories/-1/edit"

        expect(assigns(:story)).to be_a_new(Story)
      end
    end
  end

  describe "GET new" do
    it 'should create a new Story instance and assign it to @story' do
      get "/en/stories/new"

      expect(assigns(:story)).to be_a_new(Story)
    end
  end

  describe "GET show" do
    it 'should get the story and assign it to @story' do
      get "/en/stories/#{@rudo_story.id}"

      expect(assigns(:story)).to eq(@rudo_story)
    end
  end

  describe "POST create" do
    it 'should redirect to :show' do
      post "/en/stories", params: {
        story: {
          title: "Story title",
          desc: "Story description",
          interview_location_id: create(:place).id,
          interviewer_id: create(:speaker).id
        }
      }

      expect(response).to redirect_to(story_path(assigns(:story)))
    end
  end

  describe "PUT update" do
    before :each do
      put "/en/stories/#{@rudo_story.id}", params: {
        id: @rudo_story,
        story: {
          title: "Story title", desc: "Story description", interview_location_id: @rfg2018, interviewer_id: @miranda
        }
      }
    end

    it 'should get the story and assign it to @story' do
      expect(assigns(:story)).to eq(@rudo_story)
    end

    it 'should redirect to :show' do
      expect(response).to redirect_to(story_path(assigns(:story)))
    end
  end
end
