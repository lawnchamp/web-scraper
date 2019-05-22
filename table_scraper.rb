class TableScraper
  def initialize(page)
    @table = page.css('table')
    @headers = get_headers(@table)
    @data = {}
  end

  def get_data_from_columns(columns_names_to_select)
    column_indexes_to_select = columns_names_to_select.map{ |column_name| @headers.index(column_name) }.compact

    @table.search('tr').each do |row_of_nodes|
      entire_row_of_text = row_of_nodes.search('td, th').map{ |cell| cell.text.strip }
      row_filtered_by_interest = entire_row_of_text.values_at(*column_indexes_to_select)

      index_data_with = row_filtered_by_interest.shift
      @data[index_data_with] = row_filtered_by_interest 
    end

    @data
  end

  def get_headers(table)
    table.search('th').map{ |header_node| header_node.text.strip }
  end
end