# web-scraper

## Usage
`ruby run_web_scraper.rb -h` to see all arguments you can pass in

`username` and `password` are the only mandatory params 
`ruby run_web_scraper.rb --username joe_shmoe --password password123`

## Running specs
`$ rspec`

## Overview
### run_web_scraper.rb 
- sets defaults for params and takes in `username` and `password`
- calls `DominionEnergyBillScraper` to login and collect data
- writes data to a csv (`scraped_data.csv` by default)
- calculates service start and end date and prints to the terminal
### DominionEnergyBillScraper
- logs into `LOGIN_URL = 'https://mya.dominionenergy.com/'`
- collects tax data from `PAST_USAGE_URL = 'https://mya.dominionenergy.com/Usage/ViewPastUsage?statementType=3&startYear=2016`
- collects usage data from `PAST_USAGE_URL = 'https://mya.dominionenergy.com/Usage/ViewPastUsage?statementType=4&startYear=2016`
### TableScraper
- Takes in a `Mechanize::Page` and searches for a table which is a `Nokogiri::XML::NodeSet`
- `TableScraper#get_data_from_columns` scrapes one table and turns it into a hash.


## Future work
1. In `DominionEnergyBillScraper#collecting_data_from` two hash tables are merged. This merge is really straight forward because the two tables have all the same dates. If the tax page had more dates than the usage page I would have needed a more sophisticated merge
```
taxes_data.merge(usage_data) do |matching_key, taxes_data, usage_data|
  taxes_data + usage_data
end
```

2. The way that I calculate service start and end date is inificent and untested. I was ok with this because in a real project I would be reading these dates into a database which would make getting start and end date pretty easy. 
```
dates = scraped_data
  .keys
  .select{ |key| key =~ /\d{2}\/\d{2}\/\d{4}/ }
  .map{ |date| Date.strptime(date, '%m/%d/%Y') }
  .sort

puts "Service start date: #{dates.first}"
puts "Service end date: #{dates.last}"
puts "See #{params[:csv_output_name]} to view data"
```

3. I only let user give the year to start collecting data at. It wouldn't take much more time to let user specify start year, start month, end year, and end month. `https://mya.dominionenergy.com/Usage/ViewPastUsage` allows you to pass those params in.

4. `TableScraper#get_data_from_columns` breaks if the page has multiple tables on it. I would handle this with raising an exception if there are more than 1 table or return an array of hashes if there are multiple tables. 
