require 'rubygems'
require 'builder'
require 'csv'

@cell_size = 10
@width = ( (1830..1945).to_a.size * @cell_size ) + 100
@height = 90 * @cell_size * 2

s = Builder::XmlMarkup.new( :target => $stdout, :indent => 2 )
s.instruct!

s.svg :width => @width, 
	:height => @height,  
	:viewBox => "0 0 #{@width} #{@height}",
	:xmlns => "http://www.w3.org/2000/svg",
	:version => "1.1",
	:baseProfile => "full" do

	8.times do |i|
		s.rect :x => (i * 20 * @cell_size) + (@cell_size / 2), :y => 0, :width => 10 * @cell_size, :height => @height, :style => "fill:#f0f5fa;"
		# s.text :x => i * 20 * @cell_size, :y => 10 do 
		# 	"#{1830 + (i * 10)}s"
		# end
	end

	CSV.foreach('data/pp-titles.csv', :headers => true) do |row|

		year = row['Year'].to_i - 1829
		titles = row.headers

		cx = year.to_i * @cell_size
		titles.each_with_index do |title, i|
			if i > 0
				cy = ( @cell_size * i * 2 ) + ( @cell_size * 2 )

				r = (Math.sqrt(row[title].to_f / Math::PI) / 60) * (@cell_size / 2)
				r = [ [ r, 1.2].max, row[title].to_i ].min
	       		
	       		s.circle :cx => cx, :cy => cy, :r => r, :style => "stroke: #89a; stroke-width:1;fill:#678;"
				# s.rect :x => cx, :y => cy - (r), :width => @cell_size, :height => r*2, :style => "stroke: #89a; stroke-width:1;fill:#678;"
			end
		end

	end

end


