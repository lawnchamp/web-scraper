require 'CSV'
require './dominion_energy_bill_scraper'
require './table_scraper'
require 'pry-nav'

require 'optparse'

# settings defaults params
params = {
  start_year: '2016',
  columns_to_collect: ['Date','Bill Amount', 'Due Date', 'Meter Read Date', 'Usage (kWh)'],
  equivalent_column_names: ['Date', 'Meter Read Date'],
  csv_output_name: 'scraped_data.csv'
}

OptionParser.new do |parser|
  parser.banner = "Usage: example.rb [params]"

  parser.on('-u', '--username=USERNAME', 'Dominion username') { |v| params[:username] = v }
  parser.on('-p', '--password=PASSWORD', 'Dominion password') { |v| params[:password] = v }
  parser.on('-y', '--start_year=START_YEAR', 'Year to start data collection at') { |v| params[:start_year] = v }
  parser.on('-f', '--file_output=FILE_OUTPUT', 'csv output filename') { |v| params[:csv_output_name] = v }
end.parse!

if params[:username].nil? or params[:password].nil?
  raise 'Error: both username and password are required. use -h for help "$ruby run_web_scraper.rb -h"'
end


dominion_energy_scraper = DominionEnergyBillScraper.new
dominion_energy_scraper.login(params[:username], params[:password])

scraped_data = dominion_energy_scraper.collecting_data_from(
  params[:start_year],
  params[:columns_to_collect],
  params[:equivalent_column_names]
)

CSV.open(params[:csv_output_name], "w") do |csv_row|
  equivalent_names = params[:equivalent_column_names]
  if scraped_data.has_key?(equivalent_names[0])
    header = [equivalent_names[0]] + scraped_data.delete(equivalent_names[0])
  else
    header = [equivalent_names[1]] + scraped_data.delete(equivalent_names[1])
  end
  csv_row << header

  scraped_data.each do |date, values|
    csv_row << [date] + values
  end
end

# Not efficent way of getting start and end date. But if data was read into database this would go away
dates = scraped_data
  .keys
  .select{ |key| key =~ /\d{2}\/\d{2}\/\d{4}/ }
  .map{ |date| Date.strptime(date, '%m/%d/%Y') }
  .sort

puts "Service start date: #{dates.first}"
puts "Service end date: #{dates.last}"
puts "See #{params[:csv_output_name]} to view data"

# notes
# would have made table merger smarter by padding empty cells if there was no conflict.
#   It was convienent that dates from two
# would let user have control of when they wanted to query data from
