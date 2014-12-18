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

require './accesscodes.rb'

include AccessCode

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

get '/accesscodes' do
	set_access_codes
	if params[:access_code]
		@statement = code_to_statement(params[:access_code])
	end
	haml :accesscodes, locals: { access_spaces: @access_spaces, access_questions: @access_questions }
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

def code_to_statement(code)
	statement = {
		:message => '',
		:details => []
	}
	code = code.to_s
	if not code =~ /\d\d\d/
		return {:error => "Not a valid access code."}
	end
	little_code = code[0].to_i
	big_code = code[1..2].to_i
	if little_code > 4 or big_code > 63
		return {:error => "Not a valid access code."}
	end
	statement[:message] = @access_spaces[little_code]
	sprintf("%06b", big_code).split('').each_with_index do |c, i|
		if c == "1"
			statement[:details][i] = {
				:outcome => true,
				:message => @access_on[i]
			}
		else
			statement[:details][i] = {
				:outcome => false,
				:message => @access_off[i]
			}
		end
	end
	statement
end

def set_access_codes
	@access_spaces =  [
		"Full and free access",
		"Open access",
		"Restricted (copyright)",
		"Restricted (location)",
		"Restricted (person)"
	]

	@access_questions =  [
		"Physical access restricted to NLNZ?",
		"In copyright?",
		"Permission required for reuse?",
		"Download restricted?",
		"Charge for download?",
		"Commercial use banned?"
	]

	@access_on =  [
		"Physical access for this item is restricted to National Library.",
		"This item is in copyright.",
		"Permission is required for the reuse of this item.",
		"You may not download a digital copy of this item.",
		"A high-quality copy of this item is available for pucrhase.",
		"You may not use this item for commercial purposes."
	]

	@access_off =  [
		"This item can be accessed from the Internet.",
		"There is no known copyright on this item.",
		"You have the blessing of the National Library to use this item as you see fit.",
		"Copies of this item is available are available for download.",
		"There is no charge to use this item.",
		"Commercial use is permitted."
	]
end