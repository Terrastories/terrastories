require 'rails_helper'

RSpec.describe Importing::StoriesImporter, type: :model do
  let(:headers) do
    %w(Title_of_story
       Description
       Speaker_name
       Place_name
       Where_interviewed
       Date_interview
       Interviewer
       Language
       Video
       Restricted_to_user)
  end

  let(:data) do
    CSV.generate(headers: true) do |csv|
      csv << headers
      csv << attributes
    end
  end

  let(:import) { Story.import(data) }
  let(:attributes) do
    ['The Story of Mary Frank', 'Some description', 'Mary Frank',
     'Suki', 'New York', '10/09/2019', 'R. Sallon', 'Matawai', nil, 'yes']
  end

  context 'general' do
    it 'imports stories from file' do
      expect { import }.to change { Story.count }.by(1)

      story = Story.find_by(title: attributes[0])

      expect(story).to_not be_nil
      expect(story.desc).to eq(attributes[1])
      expect(story.date_interviewed.to_date).to eq(Date.today)
      expect(story.language).to eq(attributes[7])
      expect(story.permission_level).to eq('user_only')
    end
  end

  shared_examples 'imports relations' do |model, relation_name, has_many, base_increment|
    it "creates #{model.name.pluralize}" do
      increment = base_increment + relations_attributes.size
      expect { import }.to change { model.count }.by(increment)

      story = Story.find_by(title: attributes[0])
      if has_many
        expect(story.public_send(relation_name).size).to eq(relations_attributes.size)
      end

      relations_attributes.each do |attrs|
        relation = model.find_by(attrs)
        expect(relation).to_not be_nil

        if has_many
          expect(story.public_send(relation_name)).to include(relation)
        else
          expect(story.public_send(relation_name)).to eq(relation)
        end
      end.empty? and begin
        expect(story.public_send(relation_name)).to be_nil
      end
    end

    it "does not create #{model.name.pluralize} when they exist" do
      relations_attributes.each do |attrs|
        model.create!(attrs)
      end
      expect { import }.to change { model.count }.by(base_increment)
    end
  end

  context 'speakers' do
    context 'with one speaker' do
      let(:relations_attributes) { [{ name: attributes[2] }] }
      it_behaves_like 'imports relations', Speaker, :speakers, true, 1
    end

    context 'with multiple speakers' do
      before(:each) do
        attributes[2] = 'Mary Frank, John Doe'
      end

      let(:relations_attributes) do
        attributes[2].split(',').map do |name|
          { name: name.strip }
        end
      end

      it_behaves_like 'imports relations', Speaker, :speakers, true, 1
    end

    context 'with no speakers' do
      it 'throws an error' do
        attributes[2] = nil
        expect { import }.to raise_error(ImportError, 'Speakers cannot be empty!')
      end
    end
  end

  context 'places' do
    context 'with one place' do
      let(:relations_attributes) { [{ name: attributes[3] }] }
      it_behaves_like 'imports relations', Place, :places, true, 1
    end

    context 'with multiple places' do
      before(:each) do
        attributes[3] = 'Suki,Tokyo'
      end

      let(:relations_attributes) do
        attributes[3].split(',').map do |name|
          { name: name.strip }
        end
      end

      it_behaves_like 'imports relations', Place, :places, true, 1
    end

    context 'with no places' do
      it 'throws an error' do
        attributes[3] = nil
        expect { import }.to raise_error(ImportError, 'Places cannot be empty!')
      end
    end
  end

  context 'interview location' do
    context 'present' do
      let(:relations_attributes) { [{ name: attributes[4] }] }
      it_behaves_like 'imports relations', Place, :interview_location, false, 1
    end

    context 'not present' do
      before do
        attributes[4] = nil
      end

      let(:relations_attributes) { [] }
      it_behaves_like 'imports relations', Place, :interview_location, false, 1
    end
  end

  context 'interviewer' do
    context 'present' do
      let(:relations_attributes) { [{ name: attributes[6] }] }
      it_behaves_like 'imports relations', Speaker, :interviewer, false, 1
    end

    context 'not present' do
      before do
        attributes[6] = nil
      end

      let(:relations_attributes) { [] }
      it_behaves_like 'imports relations', Speaker, :interviewer, false, 1
    end
  end

  context 'permission level' do
    context 'when blank' do
      it 'it is set to anonymous' do
        attributes[9] = nil
        import
        story = Story.find_by(title: attributes[0])
        expect(story.permission_level).to eq('anonymous')
      end
    end

    context 'when present' do
      it 'it is set to anonymous' do
        import
        story = Story.find_by(title: attributes[0])
        expect(story.permission_level).to eq('user_only')
      end
    end
  end
end
