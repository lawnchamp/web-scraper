require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'mechanize'

class DominionEnergyBillScraper
  # was torn about where to store these URLS and if they should be configurable
  LOGIN_URL = 'https://mya.dominionenergy.com/'
  PAST_USAGE_URL = 'https://mya.dominionenergy.com/Usage/ViewPastUsage'
  USAGE = 4
  TAXES = 3

  def initialize
    @agent = Mechanize.new
  end

  def login(username, password, login_url = LOGIN_URL)
    login_page = @agent.get(login_url)
    
    login_form = login_page.form('Login')
    login_form.field_with(:name => 'USER').value = username
    login_form.field_with(:name => 'PASSWORD').value = password
    
    @agent.submit login_form
  end

  def collecting_data_from(start_year, collect_column_names, equivalent_column_names)
    taxes_data = scrape(TAXES, start_year, collect_column_names)
    usage_data = scrape(USAGE, start_year, collect_column_names)

    rename_key(taxes_data, equivalent_column_names[0], equivalent_column_names[1])
    rename_key(usage_data, equivalent_column_names[0], equivalent_column_names[1])
    
    taxes_data.merge(usage_data) do |matching_key, taxes_data, usage_data|
      taxes_data + usage_data
    end
  end

  def scrape(statement_type, start_year, columns_headers)
    page = @agent.get("#{PAST_USAGE_URL}?statementType=#{statement_type}&startYear=#{start_year}")
    if !page.uri.to_s.include? PAST_USAGE_URL
      raise "Error: unable to reach #{PAST_USAGE_URL}. Ensure login at #{LOGIN_URL} works with credentials given"
    end

    table_scraper = TableScraper.new(page)
    table_scraper.get_data_from_columns(columns_headers)
  end

  def rename_key(hash, old_key_name, new_key_name)
    if hash.has_key? old_key_name
      removed_data = hash.delete(old_key_name)
      hash[new_key_name] = removed_data
    end
  end
end