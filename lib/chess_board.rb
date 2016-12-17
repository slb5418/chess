require_relative "pieces"

class ChessBoard
	#include Enumerable
	attr_accessor :board, :pieces

	def initialize
		@board = Array.new(8){Array.new(8)}
		setup_board()
	end

	def [] board_index
		@board[board_index]
	end

	def each(&block)
		@board.each(&block)
	end

	def setup_board
		board[0][0] = Rook.new('black', [0,0])
		board[0][1] = Knight.new('black', [0,1])
		board[0][2] = Bishop.new('black', [0,2])
		board[0][3] = Queen.new('black', [0,3])
		board[0][4] = King.new('black', [0,4])
		board[0][5] = Bishop.new('black', [0,5])
		board[0][6] = Knight.new('black', [0,6])
		board[0][7] = Rook.new('black', [0,7])
		(0..7).each {|i| board[1][i] = Pawn.new('black', [1,i])}

		board[7][0] = Rook.new('white', [7,0])
		board[7][1] = Knight.new('white', [7,1])
		board[7][2] = Bishop.new('white', [7,2])
		board[7][3] = Queen.new('white', [7,3])
		board[7][4] = King.new('white', [7,4])
		board[7][5] = Bishop.new('white', [7,5])
		board[7][6] = Knight.new('white', [7,6])
		board[7][7] = Rook.new('white', [7,7])
		(0..7).each {|i| board[6][i] = Pawn.new('white', [6,i])}
	end

    def format_row(arr)
        arr.map do |column|
            if column.nil?
                " * "
            else
                column.to_s
            end
        end * ' '
    end

    def format_board
    	display = ["\n"]
    	board_index = 8
        board.map do |row|
            display << format_row(row) + "  #{board_index}"
            board_index = board_index - 1
        end
        col_map = " A   B   C   D   E   F   G   H"
        display.join("\n") + "\n\n" + col_map + "\n\n"
    end
end

if __FILE__ == $0
	cb = ChessBoard.new()
	puts cb.format_board
end


