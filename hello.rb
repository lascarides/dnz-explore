# encoding: utf-8

require 'rubygems'
require "bundler/setup"
require 'sinatra'
require 'haml'
require 'json'
require 'net/http'
require 'yaml'
require 'csv'
require 'digest/sha1'

set :static, true
set :root, File.dirname(__FILE__)
set :cache_time, 1

get '/' do
	haml :index, locals: { collections: fetch_collection_details }
end

get '/histo' do
	haml :histo, locals: { collections: fetch_collection_details }
end

def fetch_collection_details

	collections = []

	CSV.foreach("data/data.csv", { :col_sep => "\t" }) do |row|
	
		collections << {
			collection_name: 		row[1].to_s.strip,
			collection_group_name: 	row[0].to_s.strip,
			item_count: 			row[2].to_i,
			org_name: 				row[3].to_s.strip,
			org_color: 				Digest::SHA1.hexdigest(row[3].strip).to_s[0..5],
			item_log_count: 		row[4].to_f,
			item_dot_count: 		(row[2].to_f / 10000).to_i + 1,
			item_magnitude: 		(row[2].to_s.size * 1.7).to_i
		}

	end

	collections

end
