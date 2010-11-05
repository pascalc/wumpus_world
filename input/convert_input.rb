#!/usr/bin/env ruby

if ARGV.length != 1
	puts "Usage: convert_input.rb <input_file>" 
	exit
end

infile_name = ARGV[0]
input = File.open(infile_name, "r")
outfile_name = infile_name.sub (/\w+/) { |w| w << "_converted" } 
output = File.open(outfile_name, "w")

(ROWS,COLS) = input.gets.chomp.split.map { |c| c.to_i }
(X_Origin,Y_Origin) = input.gets.chomp.split.map { |c| c.to_i }

translate = {
	"0" => "0",
	"B" => "1",
	"S" => "2",
	"G" => "3",
	"BS" => "4",
	"BG" => "5",
	"SG" => "6",
	"BSG" => "7"
}

wumpus_world = []
ROWS.times { wumpus_world << [0]*COLS }
ROWS.times do |i|
	row = input.gets.chomp.split
	COLS.times do |j|
		wumpus_world[j][i] = translate[row[j]]
	end
end
wumpus_world.map { |col| col.reverse! }

ROWS.times do |x|
       COLS.times do |y|
	       output.puts "#{x-X_Origin} #{y-Y_Origin} #{wumpus_world[x][y]}"
       end	       
end
