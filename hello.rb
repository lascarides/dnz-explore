# encoding: utf-8

require 'rubygems'
require "bundler/setup"
require 'sinatra'
require 'nokogiri'
require 'haml'
require 'json'
require 'net/http'
require 'yaml'
require 'csv'
require 'digest/sha1'
require 'open-uri'


set :static, true
set :root, File.dirname(__FILE__)
set :cache_time, 1

get '/' do
	haml :index, locals: { collections: fetch_collection_details }
end

get '/popular' do

	items = []
	CSV.foreach("data/popular-modded.csv", { :col_sep => "\t" }) do |row|
		items << [ row[0], row[1], row[2], row[3], row[4] ]
	end
	haml :popular, locals: { items: items }

end

get '/histo' do
	haml :histo, locals: { collections: fetch_collection_details }
end

get '/xmas' do
	# Christmas Set
	# http://www.digitalnz.org/user_sets/52aa17538d2a4e8fcc00001d.xml
	doc = Nokogiri::Slop(open("http://www.digitalnz.org/user_sets/52aa17538d2a4e8fcc00001d.xml"))
	doc.remove_namespaces!
	haml :xmas, locals: { records: doc.xpath('//record') }
end

def fetch_collection_details

	collections = []

	CSV.foreach("data/data.csv", { :col_sep => "\t" }) do |row|
	
		collections << {
			collection_name: 		row[0].to_s.strip,
			collection_group_name: 	row[1].to_s.strip,
			item_count: 			row[2].to_i,
			org_name: 				row[3].to_s.strip,
			org_color: 				row[4].to_s.strip,
			item_log_count: 		Math.log(row[5].to_i),
			item_dot_count: 		row[6].to_i,
			item_magnitude: 		row[7].to_i,
			format: 				row[8].to_s.strip,
			format_color: 			Digest::SHA1.hexdigest(row[8].to_s.strip).to_s[1..6]
		}

	end

	collections

end
