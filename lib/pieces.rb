class Piece
	attr_accessor :color, :position

	def initialize(color, coords)
		@color = color
		@position = coords
	end
end

def horizontal_moves(position)
	pos_horizontal_moves(position) + neg_horizontal_moves(position)	
end

def pos_horizontal_moves(position)
	x,y = position
	pos_moves = (y+1..7).map{|y| [x,y]}
end

def neg_horizontal_moves(position)
	x,y = position
	neg_moves = (y-1).downto(0).map{|y| [x,y]}
end

def vertical_moves(position)
	pos_vertical_moves(position) + neg_vertical_moves(position)
end

def pos_vertical_moves(position)
	x,y = position
	pos_moves = (x+1..7).map{|x| [x,y]}
end

def neg_vertical_moves(position)
	x,y = position
	neg_moves = (x-1).downto(0).map{|x| [x,y]}
end

def diagonal_moves(position)
	diag_right(position) + diag_left(position) \
	+ diag_reverse_right(position) + diag_reverse_left(position)
end

def diag_right(position)
	x,y = position
	diagonal_moves = []
	while x < 7 && y < 7
		x += 1
		y += 1
		diagonal_moves << [x,y]
	end
	return diagonal_moves
end

def diag_left(position)
	x,y = position
	diagonal_moves = []
	while x < 7 && y > 0
		x += 1
		y -= 1
		diagonal_moves << [x,y]
	end
	diagonal_moves
end

def diag_reverse_right(position)
	x,y = position
	diagonal_moves = []
	while x > 0 && y < 7
		x -= 1
		y += 1
		diagonal_moves << [x,y]
	end
	diagonal_moves
end

def diag_reverse_left(position)
	x,y = position
	diagonal_moves = []
	while x > 0 && y > 0
		x -= 1
		y -= 1
		diagonal_moves << [x,y]
	end
	diagonal_moves
end

class Pawn < Piece

	def valid_moves
		x,y = self.position
		if self.color == "black"
			potential_moves = x==1 ? [[x+1, y], [x+2, y]] : [[x+1, y]]
		else # white
			potential_moves = x==6 ? [[x-1, y], [x-2, y]] : [[x-1, y]]
		end
		valid_moves = potential_moves.select{|item| item if \
					item[0]>=0 && item[0]<=7 && item[1]>=0 && item[1]<=7}
	end

	def to_s
		color == 'white' ? " \u265F " : " \u2659 "
	end
end	

class Rook < Piece
	def valid_moves
		horizontal_moves(self.position) + vertical_moves(self.position)
	end

	def to_s
		color == 'white' ? " \u265C " : " \u2656 "
	end
end

class Knight < Piece
	def valid_moves
		x,y = self.position
		potential_moves = [[x+2, y+1], [x+2, y-1], [x+1, y+2], [x+1, y-2],
							[x-2, y+1], [x-2, y-1], [x-1, y+2], [x-1, y-2]]
		valid_moves = potential_moves.select{|item| item if \
					item[0]>=0 && item[0]<=7 && item[1]>=0 && item[1]<=7}
	end

	def to_s
		color == 'white' ? " \u265E " : " \u2658 "
	end
end

class Bishop < Piece
	def valid_moves
		diagonal_moves(self.position)
	end

	def to_s
		color == 'white' ? " \u265D " : " \u2657 "
	end
end

class King < Piece
	def valid_moves
		x,y = self.position
		potential_moves = [[x+1,y], [x-1, y], [x, y+1], [x, y-1], 
					   [x+1, y+1], [x+1, y-1], [x-1, y-1], [x-1, y+1]]
		valid_moves = potential_moves.select{|item| item if \
					item[0]>=0 && item[0]<=7 && item[1]>=0 && item[1]<=7}
	end

	def to_s
		color == 'white' ? " \u265A " : " \u2654 "
	end
end

class Queen < Piece
	def valid_moves
		horizontal_moves(self.position) + vertical_moves(self.position) \
		+ diagonal_moves(self.position)
	end

	def to_s
		color == 'white' ? " \u265B " : " \u2655 "
	end
end

if __FILE__ == $0
	p = Pawn.new('black', [0,0])
	puts p.color
	puts p.position
end