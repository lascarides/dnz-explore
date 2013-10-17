API_KEY = 'iaStyqKuqiBjgS7J6Td5'

require 'rubygems'
require 'json'
require 'csv'
require 'net/http'
require 'digest/sha1'

def get_record(id)
	url = " http://api.digitalnz.org/v3/records/#{id}.json?api_key=#{API_KEY}"
	response = Net::HTTP.get_response(URI.parse(url)).body.force_encoding("UTF-8")
	result = JSON.parse(response)
	result['record']
end


# csv << [
# 	'collection_name',
# 	'collection_group_name',
# 	'item_count',
# 	'org_name',
# 	'org_color',
# 	'item_log_count',
# 	'item_dot_count',
# 	'item_magnitude',
# 	'format'
# ]

coll = CSV.generate(:col_sep => "\t") do |csv|
	CSV.foreach("data/popular.csv", { :col_sep => "\t" }) do |row|
		record = get_record(row[0])
		csv << [
			row[0],
			row[1],
			record['landing_url'],
			record['thumbnail_url'],
			record['title']
		]
	end
end

puts coll