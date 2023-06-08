require 'csv'

module CSVHeaders
  def self.get_headers(file_name)
    return unless File.exist?(file_name)

    headers = nil
    CSV.open(file_name, 'r') do |csv|
      headers = csv.first
    end

    headers
  end
end
