require_relative '../table_scraper'
require 'nokogiri'

describe TableScraper do
  let(:columns_names_to_select) {['Date','Bill Amount', 'Due Date', 'Meter Read Date', 'Usage (kWh)']}

  it 'can read age_table' do
    page = File.read('spec/age_table.html')
    scraper = TableScraper.new(Nokogiri::HTML(page))

    expect(scraper.get_data_from_columns(['Birth Date','Firstname', 'Age'])).to eq({
      'Birth Date'=>['Firstname','Age'],
      '04/20/1969'=>['Jill','50'],
      '05/24/1925'=>['Eve','94'],
      '09/10/1939'=>['John','80']
    })
  end

  it 'can read usage_page' do
    page = File.read('spec/usage_page.html')
    scraper = TableScraper.new(Nokogiri::HTML(page))

    expect(scraper.get_data_from_columns(columns_names_to_select)).to eq({
      'Meter Read Date'=>['Usage (kWh)'],
      '04/24/2019'=>['670'],
      '03/25/2019'=>['581'],
      '02/22/2019'=>['590'],
      '01/24/2019'=>['652'],
      '12/21/2018'=>['605'],
      '11/21/2018'=>['758'],
      '10/22/2018'=>['924'],
      '09/21/2018'=>['990'],
      '08/22/2018'=>['1016'],
      '07/24/2018'=>['1098'],
      '06/22/2018'=>['985'],
      '05/23/2018'=>['859'],
      '04/24/2018'=>['674'],
      '03/23/2018'=>['631'],
      '02/22/2018'=>['482'],
      '01/24/2018'=>['604'],
      '12/22/2017'=>['638'],
      '11/22/2017'=>['798'],
      'Totals'=>['13555.0']
    })
  end

  it 'can read taxes_page' do
    page = File.read('spec/taxes_page.html')
    scraper = TableScraper.new(Nokogiri::HTML(page))

    expect(scraper.get_data_from_columns(columns_names_to_select)).to eq({
      'Date'=>['Bill Amount', 'Due Date'],
      '04/24/2019'=>['$82.07', '05/17/2019'],
      '03/25/2019'=>['$72.50', '04/18/2019'],
      '02/22/2019'=>['$73.32', '03/19/2019'],
      '01/24/2019'=>['$79.30', '02/18/2019'],
      '12/21/2018'=>['$73.20', '01/18/2019'],
      '11/21/2018'=>['$90.03', '12/19/2018'],
      '10/22/2018'=>['$106.13', '11/19/2018'],
      '09/21/2018'=>['$117.67', '10/16/2018'],
      '08/22/2018'=>['$121.05', '09/17/2018'],
      '07/24/2018'=>['$130.73', '08/16/2018'],
      '06/22/2018'=>['$116.66', '07/18/2018'],
      '05/23/2018'=>['$99.94', '06/18/2018'],
      '04/24/2018'=>['$81.04', '05/17/2018'],
      '03/23/2018'=>['$77.04', '04/18/2018'],
      '02/22/2018'=>['$60.50', '03/19/2018'],
      '01/24/2018'=>['$73.96', '02/16/2018'],
      '12/22/2017'=>['$77.53', '01/18/2018'],
      '11/22/2017'=>['$95.23', '12/19/2017'],
      'Totals'=>['$1,627.90', nil]
    })
  end
end