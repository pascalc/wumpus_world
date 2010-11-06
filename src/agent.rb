#!/usr/bin/env ruby

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
		puts "Beginning to EXPLORE..."

		@knowledge_base.clear
		@explored.clear

		origin = Pos.new(0,0)
		origin_state = @ww.perceive(origin)
		@knowledge_base[origin] = origin_state
		infer(origin)
		@explored << origin
		base = origin

		loop do
			puts "-"*70
			puts "BASE = (#{base.x},#{base.y})"
			puts "EXPLORED #{@explored}"
			puts

			moves = @CROSS_MOVES.shuffle + @DIAGONAL_MOVES.shuffle
			moves_made = 0
			next_base = base
			moves.each do |m|
				newX = base.x + m[0]
				newY = base.y + m[1]
				new_pos = Pos.new(newX,newY)
				if isSafe(new_pos) and (not @explored.include?(new_pos))
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
					if not state.black
						next_base = new_pos
					end
					move_to(base)
				end
			end
			if moves_made == 0
				escape(base)
			end
			puts "CHANGE BASE (#{base.x},#{base.y}) -> (#{next_base.x},#{next_base.y})" 
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
			if adj_state.nil?
				adj_state = State.new
				adj_state.pitPossibility = 0
				adj_state.wumpusPossibility = 0
			end

			if not @explored.include?(adjacent_pos)
				if state.empty
					adj_state.empty = true
					puts "Inferred that (#{adjacent_pos.x},#{adjacent_pos.y}) is empty"
				else
					if state.breezy
						adj_state.pitPossibility = adj_state.pitPossibility + 1
						puts "Inferred that (#{adjacent_pos.x},#{adjacent_pos.y}) could have a pit"
					end
					if state.smelly
						adj_state.wumpusPossibility = adj_state.wumpusPossibility + 1
						puts "Inferred that (#{adjacent_pos.x},#{adjacent_pos.y}) could have a wumpus"
					end
				end
			end
			@knowledge_base[adjacent_pos] = adj_state
		end
	end
	
	def isSafe(pos)
		state = @knowledge_base[pos]
		#puts "Couldn't find (#{pos.x},#{pos.y}) in the knowledge base" if state.nil?
		if state.nil? or state.black
			res = false
		elsif state.empty or (state.pitPossibility == 0 and state.wumpusPossibility == 0)
			res = true
		else
			res = false
		end
		puts "\n(#{pos.x},#{pos.y}) is #{"not" if res == false} safe"
		return res
	end

	def escape(pos)
		puts "Escaping from (#{pos.x},#{pos.y})!"
	 	if @found_gold
			exit
		else
			explore
		end
	end
end

agent = Agent.new ARGV[0]
agent.explore
