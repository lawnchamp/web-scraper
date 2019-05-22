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

  describe '#collecting_data_from' do
    let(:dominion_energy_scraper) { DominionEnergyBillScraper.new }
    let(:usage_data) {{
      'Meter Read Date' => ['Usage (kWh)'],
      '04/24/2019' => ['670'],
      '03/25/2019' => ['581']
    }}
    let(:tax_data) {{
      'Date' => ['Bill Amount', 'Due Date'],
      '04/24/2019' => ['$82.07','05/17/2019'],
      '03/25/2019' => ['$72.50','04/18/2019']
    }}


    before do
      allow(dominion_energy_scraper).to receive(:scrape).and_return(tax_data, usage_data)
    end

    it 'properly merges two hashes' do
      merged_data = dominion_energy_scraper.collecting_data_from('', [], ['Date', 'Meter Read Date'])

      expect(merged_data).to eq({
        "Meter Read Date"=>["Bill Amount", "Due Date", "Usage (kWh)"],
        "04/24/2019"=>["$82.07", "05/17/2019", "670"],
        "03/25/2019"=>["$72.50", "04/18/2019", "581"]
      })
    end
  end
end
