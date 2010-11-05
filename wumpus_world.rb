Pos = Struct.new(:x,:y)

State = Struct.new(:breezy,:smelly,:glittery,:pitPossibility,
				   :wumpusPossibility,:empty,:black)

class WumpusWorld
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

	def getStateAt(pos)
		flag = @world[pos]
		state = State.new
		state.pitPossibility = state.wumpusPossibility = 0
		case flag
				when :Black
						state.black = true
				when :Empty
						state.empty = true
				when :Breeze
						state.breezy = true
				when :Stench
						state.smelly = true
				when :Glitter
						state.glittery = true
				when :BreezeStench
						state.breezy = true
						state.smelly = true
				when :BreezeGlitter
						state.breezy = true
						state.glittery = true
				when :BreezeStenchGlitter
						state.breezy = true
						state.smelly = true
						state.glittery = true
		end
		return state
	end
end
