API_KEY = 'iaStyqKuqiBjgS7J6Td5'

require 'rubygems'
require 'json'
require 'csv'
require 'net/http'
require 'digest/sha1'

def get_facets(snippet, current, threshold = 10)
	url = "http://api.digitalnz.org/v3/records.json?api_key=#{API_KEY}&per_page=0&#{snippet}&facets_per_page=150&page=1&facets=#{current}"
	response = Net::HTTP.get_response(URI.parse(url)).body.force_encoding("UTF-8")
	result = JSON.parse(response)
	result['search']['facets'][current].to_a.collect{|a,b| [a,b] if b > threshold}.compact
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
	get_facets('', 'category', 100).each do |category, count|
		get_facets("and[category][]=#{URI.escape(category)}", 'content_partner').each do |org, org_count|
			get_facets("and[category][]=#{URI.escape(category)}&and[content_partner][]=#{URI.escape(org)}", 'display_collection').each do |display_collection, display_collection_count|
				get_facets("and[category][]=#{URI.escape(category)}&and[display_collection][]=#{URI.escape(display_collection)}&and[content_partner][]=#{URI.escape(org)}", 'collection').each do |collection, collection_count|
					csv << [
						collection.to_s,
						display_collection.to_s,
						collection_count.to_i,
						org.to_s,
						Digest::SHA1.hexdigest(org.to_s).to_s[0..5],
						collection_count.to_i,
						(collection_count.to_f / 10000).to_i + 1,
						(collection_count.to_s.size * 1.7).to_i,
						category.to_s
					]
				end
			end
		end
	end
end

puts coll