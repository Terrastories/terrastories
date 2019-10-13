require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  before :each do
    fabricate_stories
  end

  describe "GET index" do
    it 'should get all stories and assign them to @stories' do
      get :index, format: :json

      Story.all.each { |s| expect(assigns(:stories)).to include(s) }
    end
  end

  describe "GET edit" do
    it 'should return 200 status code' do
      get :edit, params: { id: @miranda_story }

      expect(response.status).to eq(200)
    end

    context 'with existing :id passed' do
      subject { get :edit, params: { id: @miranda_story } }

      it 'should get the story and assign it to @story' do
        subject

        expect(assigns(:story)).to eq(@miranda_story)
      end
    end

    context 'with non-existing :id passed' do
      subject { get :edit, params: { id: -1 } }

      it 'should create a new Story instance and assign it to @story' do
        subject

        expect(assigns(:story)).to be_a_new(Story)
      end
    end
  end

  describe "GET new" do
    subject { get :new }

    it 'should return 200 status code' do
      expect(subject).to have_http_status(200)
    end

    it 'should create a new Story instance and assign it to @story' do
      subject

      expect(assigns(:story)).to be_a_new(Story)
    end
  end

  describe "GET show" do
    subject { get :show, params: { id: @miranda_story } }

    it 'should return 200 status code' do
      expect(subject).to have_http_status(200)
    end

    it 'should get the story and assign it to @story' do
      subject

      expect(assigns(:story)).to eq(@miranda_story)
    end
  end

  describe "POST create" do
    subject { post :create, params: { story: { title: "Story title", desc: "Story description", interview_location_id: @rbtb2019, interviewer_id: @corinne } } }

    before :each do
      fabricate_stories
    end

    it 'should create a new Story record' do
      expect { subject }.to change { Story.count }.by(1)
    end

    it 'should return 302 status code and redirect to :show' do
      expect(subject).to have_http_status(302)
    end

    it 'should redirect to :show' do
      expect(subject).to redirect_to(story_path(assigns(:story)))
    end
  end

  describe "PUT update" do
    subject {
      put :update,
          params: {
            id: @miranda_story,
            story: {
              title: "Story title", desc: "Story description", interview_location_id: @rbtb2019, interviewer_id: @kalimar
            }
          }
    }

    before :each do
      fabricate_stories
    end

    it 'should get the story and assign it to @story' do
      subject

      expect(assigns(:story)).to eq(@miranda_story)
    end

    it 'should update a given Story record' do
      subject

      @miranda_story.reload

      expect(@miranda_story.title).to eq("Story title")
      expect(@miranda_story.desc).to eq("Story description")
      expect(@miranda_story.interview_location_id).to eq(@rbtb2019.id)
      expect(@miranda_story.interviewer_id).to eq(@kalimar.id)
    end

    it 'should return 302 status code and redirect to :show' do
      expect(subject).to have_http_status(302)
    end

    it 'should redirect to :show' do
      expect(subject).to redirect_to(story_path(assigns(:story)))
    end
  end

  private

  def fabricate_stories
    @rfg2018 = Place.find_or_create_by(name: "Georgetown University", type_of_place: 'college campus', long: -77.073168, lat: 38.906302, region: "Washington DC")
    @rbtb2019 = Place.find_or_create_by(name: "NatureBridge Campus", type_of_place: 'nonprofit campus', long: -122.537419, lat: 37.832257, region: "California")

    @kalimar = Speaker.find_or_create_by(name: "Kalimar Maia")
    @corinne = Speaker.find_or_create_by(name: "Corinne Henk")

    @miranda_story = Story.create(
      title: "Miranda's testimonial",
      desc: "Ruby for Good 2018 team lead Miranda Wang about why she values working on Terrastories.",
      places: [@rfg2018],
      language: 'English',
      permission_level: 0,
      interview_location_id: @rfg2018.id,
      interviewer_id: @corinne.id
    )

    @rudo_story = Story.create(
      title: "Rudo's testimonial",
      desc: "ACT program manager Rudo Kemper discusses why the organization decided to start building Terrastories to support local communities retain their oral history traditions.",
      places: [@rbtb2019],
      language: 'English',
      permission_level: 0,
      interviewer_id: @kalimar.id,
      interview_location_id: @rbtb2019.id
    )
  end
end
