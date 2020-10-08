require 'rails_helper'

RSpec.describe Theme, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  let(:theme) {Theme.new()}
  it "can add sponsor logo" do
    theme.logos.attach(io: File.open("./spec/fixtures/media/terrastories.png"), filename: 'file.pdf')
    theme.valid?
    expect(theme.errors[:logos]).to be_empty
  end
end
