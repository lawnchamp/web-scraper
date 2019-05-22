require_relative '../dominion_energy_bill_scraper'

describe DominionEnergyBillScraper do
  let(:person) {{ name: 'joe', age: '87' }}

  before do
    DominionEnergyBillScraper.new.rename_key(person, :name, :firstname)
  end

  describe '#rename_key' do
    it 'removes old key name' do
      expect(person.has_key?(:name)).to be false
    end

    it 'new key name has old value' do
      expect(person[:firstname]).to eq 'joe'
    end
  end

  # todo - stub out the input for TableScraper to watch how two tables are merged
end
