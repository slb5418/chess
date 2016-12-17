require "pieces"

describe Piece do
	describe "initialize" do
		context "given black and 0, 0" do
			it "returns a piece color black at 0,0" do
				piece = Piece.new("black", [0,0])
				expect(piece).to be_kind_of(Piece)
				expect(piece.color).to eql("black")
				expect(piece.position).to eql([0,0])
			end
		end

		context "given white and 5,5" do
			it "returns a piece color white at 5,5" do
				piece = Piece.new("white", [5,5])
				expect(piece).to be_kind_of(Piece)
				expect(piece.color).to eql("white")
				expect(piece.position).to eql([5,5])
			end
		end
	end
end

describe "horizontal_moves" do
	context "given 5,5" do
		it "returns all moves in the row" do
			exp = (0..7).map{ |i| [5,i] if i != 5}.compact
			expect(horizontal_moves([5,5])).to match_array(exp)
		end
	end
end

describe "vertical_moves" do
	context "given 4,4" do
		it "returns all moves in the col" do
			exp = (0..7).map{ |i| [i,4] if i != 4}.compact
			expect(vertical_moves([4,4])).to match_array(exp)
		end
	end
end

describe "diagonal_moves" do
	context "given 4,4" do
		it "returns all moves in the diagonals" do
			exp = [[5,5], [6,6], [7,7], [5,3], [6,2], [7,1], [3,3], 
			[2,2], [1,1], [0,0], [3,5], [2,6], [1,7]]
			expect(diagonal_moves([4,4])).to match_array(exp)
		end
	end
end

describe Pawn do
	describe "valid_moves" do
		context "black pawn at 1,0" do
			it "returns 2,0 and 3,0" do
				pawn = Pawn.new("black", [1,0])
				expect(pawn.valid_moves).to match_array([[2,0], [3,0]])
			end
		end
		context "black pawn at 4,0" do
			it "returns 5,0" do
				pawn = Pawn.new("black", [4,0])
				expect(pawn.valid_moves).to match_array([[5,0]])
			end
		end
		context "white pawn at 6,0" do
			it "returns 5,0 and 4,0" do
				pawn = Pawn.new("white", [6,0])
				expect(pawn.valid_moves).to match_array([[5,0], [4,0]])
			end
		end
		context "black pawn at 4,0" do
			it "returns 3,0" do
				pawn = Pawn.new("white", [4,0])
				expect(pawn.valid_moves).to match_array([[3,0]])
			end
		end
	end
end

describe Rook do
	describe "valid_moves" do
		context "with position at 3,2" do
			it "returns all moves in col and row" do
				rook = Rook.new("white", [3,2])
				exp = horizontal_moves([3,2]) + vertical_moves([3,2])
				expect(rook.valid_moves).to match_array(exp)
			end
		end
	end
end

describe Knight do
	describe "valid_moves" do
		context "with position at 3,2" do
			it "returns all the L shaped moves" do
				knight = Knight.new("white", [3,2])
				exp = [[5,1], [5,3], [4,4], [4,0], [2,4], [2,0], [1,1], [1,3]]
				expect(knight.valid_moves).to match_array(exp)
			end
		end
	end
end

describe Bishop do
	describe "valid_moves" do
		context "with position at 3,2" do
			it "returns all diagonal moves" do
				bishop = Bishop.new("white", [3,2])
				exp = diagonal_moves([3,2])
				expect(bishop.valid_moves).to match_array(exp)
			end
		end
	end
end

describe Queen do
	describe "valid_moves" do
		context "with position at 3,2" do
			it "returns all horizontal, vertical and diagonal moves" do
				queen = Queen.new("white", [3,2])
				exp = diagonal_moves([3,2]) + horizontal_moves([3,2]) \
				+ vertical_moves([3,2])
				expect(queen.valid_moves).to match_array(exp)
			end
		end
	end
end

describe King do
	describe "valid_moves" do
		context "with position at 0,3" do
			it "returns [0,2], [1,2], [1,3], [1,4], [0,4]" do
				king = King.new("white", [0,3])
				exp = [[0,2], [1,2], [1,3], [1,4], [0,4]]
				expect(king.valid_moves).to match_array(exp)
			end
		end
		context "with position at 1,3" do
			it "returns [1,2], [2,2], [2,3], [2,4], [1,4], [0,4], [0,3], [0,2]" do
				king = King.new("white", [1,3])
				exp = [[1,2], [2,2], [2,3], [2,4], [1,4], [0,4], [0,3], [0,2]]
				expect(king.valid_moves).to match_array(exp)
			end
		end
	end
end
