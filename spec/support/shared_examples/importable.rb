shared_examples 'importable' do |file|
  let(:data) do
    File.open(Rails.root.join('spec', 'support', 'data', 'import', file)).read
  end

  it 'imports model entries' do
    initial_count = described_class.all.size

    described_class.import(data)

    expect(described_class.all.size).to be > initial_count
  end
end
