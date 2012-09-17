require "bundler/setup"

require 'sinatra'
require 'sinatra/json'
require 'matrix'
require 'fifteen_puzzle'
require 'json'


class Array
	def to_4_matrix
		matrix_rows = []
		row = []
		self.each_with_index do |e, i| 
			if ( (i + 1) % 4 == 0)
				row << e
				matrix_rows << row
				row = []				
			else
				row << e
			end
		end
		row_1, row_2, row_3, row_4 = matrix_rows
		return Matrix[row_1, row_2, row_3, row_4]
	end
end

get '/' do
	haml :index
end

post '/shuffle.json' do
	board = params[:board].map{|e| e.to_i}.to_4_matrix
	game_matrix = FifteenPuzzle::GameMatrix.new board
	json game_matrix.shuffle.matrix.to_a.flatten
end	

post '/solve.json' do
	board = params[:board].map{|e| e.to_i}.to_4_matrix
	game_matrix = FifteenPuzzle::GameMatrix.new board
	algorithm = FifteenPuzzle::AStarAlgorithm.new( game_matrix )
	algorithm.run
	solution_self_and_parents_arr = algorithm.solution.self_and_parents.map{|e| e.matrix.to_a.flatten}.reverse
	json solution_self_and_parents_arr
end