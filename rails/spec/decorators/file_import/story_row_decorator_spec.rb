require 'rails_helper'
require 'csv'

RSpec.describe FileImport::StoryRowDecorator do
  let(:csv) { CSV.parse(file_fixture('story_with_media.csv').read, headers: true).first }
  let(:community) { create(:community) }

  subject { described_class.new(csv, community) }

  example '#title'  do
    expect(subject.title).to eq csv[0]
  end

  example '#desc'  do
    expect(subject.desc).to eq csv[1]
  end

  example '#speakers'  do
    expect(subject.speakers.first).to be_a Speaker

    allow(subject).to receive(:at).and_return('')
    expect(subject.speakers).to be_empty
  end

  example '#places'  do
    expect(subject.places.first).to be_a Place

    allow(subject).to receive(:at).and_return('')
    expect(subject.places).to be_empty
  end

  example '#interview_location'  do
    expect(subject.interview_location).to be_a Place

    allow(subject).to receive(:at).and_return('')
    expect(subject.interview_location).to be_nil
  end

  example '#date_interviewed'  do
    expect(subject.date_interviewed).to be_a Date

    allow(subject).to receive(:at).and_return('')
    expect(subject.date_interviewed).to be_nil
  end

  example '#interviewer'  do
    expect(subject.interviewer).to be_a Speaker

    allow(subject).to receive(:at).and_return('')
    expect(subject.interviewer).to be_nil
  end

  example '#language'  do
    expect(subject.language).to eq 'English'

    allow(subject).to receive(:at).and_return('')
    expect(subject.language).to be_nil
  end

  example '#permission_level'  do
    expect(subject.permission_level).to eq "anonymous"

    allow(subject).to receive(:at).and_return('some string')
    expect(subject.permission_level).to eq "user_only"
  end

  example '#media'  do
    expect(subject.media).to be_a ::StoryMediaDecorator

    allow(subject).to receive(:at).and_return('')
    expect(subject.media).to be_a ::StoryMediaDecorator
  end

  it { expect(FileImport::StoryRowDecorator::METHODS_EXCEPT).to eq [:media, :to_h] }
end
