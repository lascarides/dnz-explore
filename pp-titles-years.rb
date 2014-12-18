API_KEY = 'iaStyqKuqiBjgS7J6Td5'

require 'rubygems'
require 'builder'
require 'json'
require 'csv'
require 'net/http'
require 'digest/sha1'

def get_facets(year)
	url = "http://api.digitalnz.org/v3/records.json?api_key=#{API_KEY}&and%5bcollection%5d=Papers%20Past&and%5byear%5d=#{year}&facets=collection&facets_per_page=150&per_page=0&fields=title,id"
	response = Net::HTTP.get_response(URI.parse(url)).body.force_encoding("UTF-8")
	result = JSON.parse(response)
	result['search']['facets']['collection']
end

data = {}
titles = []

(1830..1945).each do |yr|
	get_facets(yr).each do |title, count|
		unless title == "Papers Past"
			data[title] ||= {}
			data[title][yr.to_s] = count
			titles << title
		end
	end
end

titles = titles.uniq.compact

puts "["
data.each do |title, yrs|
	ttl = 0
	puts "{\"name\":\"#{title}\",\"articles\":["
	articles = []
	yrs.each do |yr, count|
		articles << "[#{yr},#{count}]"
		ttl += count.to_i
	end
	puts articles.join(',')
	puts "],\"total\":#{ttl}"
	puts "},"
end
puts "{},]"


# output = "Year"
# titles.each do |title|
# 	output += "\t#{title}"
# end
# puts output

# data.each do |year, counts|
# 	output = year
# 	titles.each do |title|
# 		output += "\t#{counts[title]}"
# 	end
# 	puts output
# end




