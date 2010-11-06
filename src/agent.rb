require './wumpus_world'

class Agent
	
	def initialize(world_file)
		@ww = WumpusWorld.new(world_file)
		@knowledge_base = {}
		@explored = []
		@found_gold = false
		@CROSS_MOVES = [[1,0],[-1,0],[0,1],[0,-1]]
		@DIAGONAL_MOVES = [[1,1],[-1,-1],[1,-1],[-1,1]]
		puts "AGENT INITIALISED"
	end	
	
	def move_to(pos)
		puts "MOVED TO: (#{pos.x},#{pos.y})"
	end

	def pick_up_gold
		puts "PICKING UP THE GOLD"
	end

	def explore
		@knowledge_base.clear
		@explored.clear

		origin = Pos.new(0,0)
		origin_state = @ww.perceive(origin)
		@knowledge_base[origin] = origin_state
		infer(origin)
		explored << origin
		base = origin

		loop do
			moves = @CROSS_MOVES + @DIAGONAL_MOVES.shuffle
			moves_made = 0
			moves.each do |m|
				newX = base.x + m[0]
				newY = base.y + m[1]
				new_pos = Pos.new(newX,newY)
				if isSafe(new_pos) and (not explored.contains(new_pos))
					move_to(new_pos)
					moves_made += 1
					state = @ww.perceive(new_pos)
					@knowledge_base[new_pos] = state
					infer(new_pos)
					@explored << new_pos
					if state.glittery
						pick_up_gold
						@found_gold = true
						escape(new_pos)
					end
					next_base = base
					if not state.black
						next_base = new_pos
					end
					move_to(base)
				end
			end
			if moves_made == 0
				escape(base)
			end
			base = next_base
			move_to(base)
		end
	end
	
	def infer(pos)
		state = @knowledge_base[pos]
		@CROSS_MOVES.each do |m| 
			adjacentX = pos.x + m[0]
			adjacentY = pos.y + m[1]
			adjacent_pos = Pos.new(adjacentX,adjacentY)

			adj_state = @knowledge_base[adjacent_pos]
			adj_state = State.new if adj_state.nil?

			if not explored.contains(adjacent_pos)
				if state.empty
					adj_state.empty = true
				else
					if state.breezy
						adj_state.pitPossibility += 1
					end
					if state.smelly
						adj_state.wumpusPossibility += 1
					end
				end
			end
			@knowledge_base[adjacent_pos] = adj_state
			end
		end
	end
	
	def isSafe(pos)
		state = @knowledge_base[pos]
		if state.black
			return false
		end
		if state.empty or (state.pitPossibility == 0 and state.wumpusPossibility == 0)
			return true
		else
			return false
		end
	end

	def escape(pos)
		puts "Escaping from (#{pos.x},#{pos.y})!"
	end

end
