require './position'

class WumpusWorld
	attr_reader :world

	def initialize(infile_name)	
		@world = {}
			
		input = File.open(infile_name, "r")

		(rows,cols) = input.gets.chomp.split.map { |c| c.to_i }
		(origin_x,origin_y) = input.gets.chomp.split.map { |c| c.to_i }

		translate = {
			"X" => :Black,
			"0" => :Empty,
			"B" => :Breeze,
			"S" => :Stench,
			"G" => :Glitter,
			"BS" =>:BreezeStench,
			"BG" => :BreezeGlitter,
			"SG" => :StenchGlitter,
			"BSG" => :BreezeStenchGlitter
		}

		matrix = []
		rows.times { matrix << [0]*cols }
		rows.times do |i|
			row = input.gets.chomp.split
			cols.times do |j|
				matrix[j][i] = translate[row[j]]
			end
		end
		matrix.map { |col| col.reverse! }

		rows.times do |x|
			   cols.times do |y|
				   @world[Pos.new(x-origin_x,y-origin_y)] = matrix[x][y]
			   end	       
		end
	end
end
