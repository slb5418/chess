require_relative "chess_board"
require_relative "pieces"

class Chess

	attr_accessor :board, :player

	keys = (1..8).map{|i| ("A".."H").map {|k| "#{k}#{i}"}}.flatten
	values = []
	7.downto(0).each {|i| (0..7).each {|j| values << [i,j] }}
	COORDINATES = Hash[keys.zip(values)]

	def initialize
		@board = ChessBoard.new()
		@p1 = Player.new("white", "one")
		@p2 = Player.new("black", "two")
		@player = @p1
	end

	def new_game
		puts welcome_message
		loop do # 
			loop do # get valid move loop
				puts board.format_board
				if player.check
					puts "You are in check! you need to move out of check" \
					" or lose!"
				end
				origin = get_input			

				puts "To where?"
				destination = converter(gets.chomp.upcase)
				
				if valid_move?(origin, destination)
					move(origin, destination)
					break
				else
					puts "Move was not valid, please try again"
				end
			end
			if player.check
				switch_player
				puts "Player #{player.id} has won the game!"
				puts board.format_board
				break
			end
			switch_player
			player.check = check?
		end
	end

	def welcome_message
		"\n" \
		"Welcome to Chess! I hope you know the rules.\n" \
		"To move a piece, specify the coordinates of the piece (ie A1)\n" \
		"Followed by the coordinates of the desired destination (ie A5)\n" \
		"White will go first!"
	end

	def get_input
		puts "Player #{self.player.id}, which piece would you like to move?"
		input = gets.chomp.upcase
		if !input.nil? && COORDINATES.has_key?(input) 
			x,y = converter(input)
			return @board[x][y].nil? ? get_input : [x,y] 
		end
	end

	def converter(key)
		COORDINATES[key]
	end

	def valid_move?(origin, destination)
		x,y = origin
		x2, y2 = destination
		piece = @board[x][y]

		return false if piece.color != player.color && !piece.nil?

		return true if piece.is_a?(Pawn) \
			        && is_diagonal?(origin, destination) \
			        && !@board[x][y].nil? \
			        && piece.color != @board[x2][y2].color \
				    && check_dest(piece.color, destination)

		return piece.valid_moves.include?(destination) \
			   && check_dest(piece.color, destination) \
			   && check_line(origin, destination) ? true : false
	end

	def is_diagonal?(o, d)
		x, y = o
		x2, y2 = d
		return true if (x2-x).abs == 1 && (y2-y).abs ==1 
	end

	def move(origin, destination)
		x,y = origin
		x2,y2 = destination
		@board[x2][y2] = @board[x][y]
		@board[x2][y2].position = [x2,y2]
		@board[x][y] = nil
	end

	def switch_player
		self.player = self.player == @p1 ? @p2 : @p1
	end

	def check_dest(color, destination)
		x,y = destination
		return true if @board[x][y] == nil || @board[x][y].color != color
		return false
	end

	def check?
		king = find_king(player.color)
		p = king.position
		pieces_los = []
		pieces_los.push(hor_piece(p),
		neg_hor_piece(p), ver_piece(p),
		neg_ver_piece(p), diag_piece(p),
		r_diag_piece(p), neg_diag_piece(p),
		neg_r_diag_piece(p)) 
		pieces_los += knight_pieces(p)

		pieces_los = pieces_los.select{|i| i if !i.nil? \
										&& i.color != king.color}

		pieces_los.each do |piece|
			return true if piece.valid_moves.include?(king.position)
		end
		return false
	end

	def find_king(color)
		board.each{|x| x.each{|y| return y if y.is_a?(King) && y.color == color}}
	end

	def check_mate?
		return false
	end

	def check_line(origin, destination)
		x,y = origin
		x2,y2 = destination
		diff_x = x2 - x
		diff_y = y2 - y
		piece = @board[x][y]

		case piece

		when Pawn
			if diff_x.abs > 1 # moving two spaces
				check_pawn(diff_x, x, y)
			end
			return true # moving one space - no line

		when Rook
			if diff_y.abs > 0 # horizontal
				return diff_y > 0 ? hor_line(x, y, y2) : hor_line_neg(x, y, y2)
			else # vertical
				return diff_x > 0 ? ver_line(x, x2, y) : ver_line_neg(x, x2, y)
			end

		when Knight
			return true

		when Bishop
			if diff_x.abs > 0 && diff_y.abs > 0
				if diff_x > 0 && diff_y > 0
					return check_diag(x,y,x2,y2)
				elsif diff_x > 0 && diff_y < 0
					return check_diag_reverse(x,y,x2,y2)
				elsif diff_x < 0 && diff_y > 0
					return check_neg_diag(x,y,x2,y2)
				else diff_x < 0 && diff_y < 0
					return check_neg_diag_reverse(x,y,x2,y2)
				end
			end

		when Queen 
			if diff_x.abs > 0 && diff_y.abs > 0
				if diff_x > 0 && diff_y > 0
					return check_diag(x,y,x2,y2)
				elsif diff_x > 0 && diff_y < 0
					return check_diag_reverse(x,y,x2,y2)
				elsif diff_x < 0 && diff_y > 0
					return check_neg_diag(x,y,x2,y2)
				else diff_x < 0 && diff_y < 0
					return check_neg_diag_reverse(x,y,x2,y2)
				end
			elsif diff_y.abs > 0 # horizontal
				return diff_y > 0 ? hor_line(x, y, y2) : hor_line_neg(x, y, y2)
			else # vertical
				return diff_x > 0 ? ver_line(x, x2, y) : ver_line_neg(x, x2, y)
			end

		when King 
			return true
		end
	end

	def check_pawn(diff_x, x, y)
		if diff_x < 0 # moving up board
			return true if @board[x-1][y].nil?
		else # moving down board
			return true if @board[x+1][y].nil?
		end
		return false
	end

	def check_diag(x,y,x2,y2)
		(x+1...x2).zip(y+1...y2).each do |x,y|
			return false if !@board[x][y].nil?
		end
		return true
	end
	def check_diag_reverse(x,y,x2,y2)
		(x+1...x2).zip((y-1).downto(y2+1)).each do |x,y|
			return false if !@board[x][y].nil?
		end
		return true
	end
	def check_neg_diag(x,y,x2,y2)
		((x-1).downto(x2+1)).zip(y+1...y2).each do |x,y|
			return false if !@board[x][y].nil?
		end
		return true
	end
	def check_neg_diag_reverse(x,y,x2,y2)
		(x-1).downto(x2+1).zip((y-1).downto(y2+1)).each do |x,y|
			return false if !@board[x][y].nil?
		end
		return true
	end
	def hor_line(x, y, y2) # check the positive horizontal
		(y+1...y2).each{|y| return false if !@board[x][y].nil?}
		return true
	end
	def hor_line_neg(x, y, y2) # check the negative horizontal	
		(y-1).downto(y2+1).each{|y| return false if !@board[x][y].nil?}
		return true
	end
	def ver_line(x, x2, y) # check the positive vertical
		(x+1...x2).each{|x| return false if !@board[x][y].nil?}
		return true
	end
	def ver_line_neg(x, x2, y) # check the negative vertical	
		(x-1).downto(x2+1).each{|x| return false if !@board[x][y].nil?}
		return true
	end

	def hor_piece(pos) # return the first horizontal piece
		x,y = pos
		(y+1..7).each{|y| return @board[x][y] if !@board[x][y].nil?}
		return nil
	end
	def neg_hor_piece(pos) # return the first -horiztonal piece
		x,y = pos
		((y-1).downto(0)).each{|y| return @board[x][y] if !@board[x][y].nil?}
		return nil
	end
	def ver_piece(pos) # check the positive vertical
		x,y = pos
		(x+1..7).each{|x| return @board[x][y] if !@board[x][y].nil?}
		return nil
	end
	def neg_ver_piece(pos) # check the negative vertical
		x,y = pos
		((x-1).downto(0)).each{|x| return @board[x][y] if !@board[x][y].nil?}
		return nil
	end
	def diag_piece(pos)
		x,y = pos
		(x+1..7).zip(y+1..7).each do |x,y|
			break if x.nil? || y.nil?
			return @board[x][y] if !@board[x][y].nil?
		end
		return nil
	end
	def r_diag_piece(pos)
		x,y = pos
		(x+1..7).zip((y-1).downto(0)).each do |x,y|
			break if x.nil? || y.nil?
			return @board[x][y] if !@board[x][y].nil?
		end
		return nil
	end
	def neg_diag_piece(pos)
		x,y = pos
		((x-1).downto(0)).zip(y+1..7).each do |x,y|
			break if x.nil? || y.nil?
			return @board[x][y] if !@board[x][y].nil?
		end
		return nil
	end
	def neg_r_diag_piece(pos)
		x,y = pos
		(x-1).downto(0).zip((y-1).downto(0)).each do |x,y|
			break if x.nil? || y.nil?
			return @board[x][y] if !@board[x][y].nil?
		end
		return nil
	end
	def knight_pieces(pos)
		x,y = pos
		knights = []
		l_shapes = [[x+2, y+1], [x+2, y-1], [x+1, y+2], [x+1, y-2],
					[x-2, y+1], [x-2, y-1], [x-1, y+2], [x-1, y-2]] 
		valid = l_shapes.select{|i| i if i[0]>=0 && i[0]<=7 && i[1]>=0 && i[1]<=7}
		valid.each do |i|
			x, y = i[0], i[1]
			piece = @board[x][y]
			knights.push(piece) if piece.is_a?(Knight)
		end
		knights
	end
end

class Player
	attr_reader :color, :id
	attr_accessor :check
	def initialize(color, id)
		@color = color
		@id = id
		@check = false
	end
end

if __FILE__ == $0
	chess = Chess.new()
	chess.new_game
	# chess.board[7][4] = nil
	# chess.board[4][3] = King.new("white", [4,3])
	# chess.board[6][4] = Knight.new("black", [6,4])
	# chess.check?
end