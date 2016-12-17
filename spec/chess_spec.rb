require "chess"

describe Chess do

	let(:chess) {Chess.new()}

	describe "check_dest" do
		context "given black and 0,0" do
			it "returns false" do
				expect(chess.check_dest("black", [0,0])).to be_falsey
			end
		end

		context "given black and 7,0" do
			it "returns true" do
				expect(chess.check_dest("black", [7,0])).to be_truthy
			end
		end
	end

	describe "check_line" do
		context "rook moves" do
			context "given 7,0 and 7,2" do
				it "returns false" do
					expect(chess.check_line([7,0], [7,2])).to be_falsey
				end
			end
			context "given 7,7 and 7,5" do
				it "returns false" do
					expect(chess.check_line([7,7], [7,5])).to be_falsey
				end
			end
			context "given 7,0 and 5,0" do
				it "returns false" do
					expect(chess.check_line([7,0], [5,0])).to be_falsey
				end
			end
			context "given 0,0 and 2,0" do
				it "returns false" do
					expect(chess.check_line([0,0], [2,0])).to be_falsey
				end
			end
		end

		context "bishop moves" do
			context "given 4,4 and 7,7" do
				it "returns false" do
					chess.board[4][4] = Bishop.new("white", [4,4])
					expect(chess.check_line([4,4],[7,7])).to be_falsey
				end
			end

			context "given 4,4 and 5,5" do
				it "returns true" do
					chess.board[4][4] = Bishop.new("white", [4,4])
					expect(chess.check_line([4,4],[5,5])).to be_truthy
				end
			end

			context "given 3,3 and 5,5" do
				it "returns true" do
					chess.board[3][3] = Bishop.new("white", [3,3])
					expect(chess.check_line([3,3],[5,5])).to be_truthy
				end
			end
		end
	end

	describe "check_diag" do
		context "given 4,4 and 7,7" do
			it "returns false" do
				expect(chess.check_diag(4,4,7,7)).to be_falsey
			end
		end

		context "given 4,4 and 5,5" do
			it "returns true" do
				expect(chess.check_diag(4,4,5,5)).to be_truthy
			end
		end

		context "given 3,3 and 5,5" do
			it "returns true" do
				expect(chess.check_diag(3,3,5,5)).to be_truthy
			end
		end
	end

	describe "check_diag_reverse" do
		context "given 4,4 and 7,1" do
			it "returns false" do
				expect(chess.check_diag_reverse(4,4,7,1)).to be_falsey
			end
		end

		context "given 4,4 and 5,3" do
			it "returns true" do
				expect(chess.check_diag_reverse(4,4,5,3)).to be_truthy
			end
		end

		context "given 3,3 and 5,1" do
			it "returns true" do
				expect(chess.check_diag_reverse(3,3,5,1)).to be_truthy
			end
		end
	end

	describe "check_neg_diag" do
		context "given 4,4 and 1,7" do
			it "returns true" do
				expect(chess.check_neg_diag(4,4,1,7)).to be_truthy
			end
		end

		context "given 4,4 and 3,5" do
			it "returns true" do
				expect(chess.check_neg_diag(4,4,3,5)).to be_truthy
			end
		end

		context "given 3,3 and 1,5" do
			it "returns true" do
				expect(chess.check_neg_diag(3,3,1,5)).to be_truthy
			end
		end
	end

	describe "check_neg_diag_reverse" do
		context "given 4,4 and 0,0" do
			it "returns false" do
				expect(chess.check_neg_diag_reverse(4,4,0,0)).to be_falsey
			end
		end

		context "given 4,4 and 3,3" do
			it "returns true" do
				expect(chess.check_neg_diag_reverse(4,4,3,3)).to be_truthy
			end
		end

		context "given 4,4 and 2,2" do
			it "returns true" do
				expect(chess.check_neg_diag_reverse(3,3,2,2)).to be_truthy
			end
		end
	end

	describe "find_king" do
		context "white king at 4,0" do
			it "returns the piece" do
				chess.board[7][4] = nil
				chess.board[4][0] = King.new("white", [4,0])
				expect(chess.find_king(chess.player.color)).to eql(chess.board[4][0])
			end
		end
	end

	describe "check?" do
		context "horizontal check" do
			it "returns true" do
				chess.board[7][4] = nil
				chess.board[4][0] = King.new("white", [4,0])
				chess.board[4][5] = Rook.new("black", [4,5])
				expect(chess.check?).to be true
			end
		end
		context "neg horizontal check" do
			it "returns true" do
				chess.board[7][4] = nil
				chess.board[4][3] = King.new("white", [4,3])
				chess.board[4][0] = Rook.new("black", [4,0])
				expect(chess.check?).to be true
			end
		end
		context "vertical check" do 
			it "returns true" do
				chess.board[7][4] = nil
				chess.board[4][3] = King.new("white", [4,3])
				chess.board[2][3] = Rook.new("black", [2,3])
				expect(chess.check?).to be true
			end
		end
		context "neg vertical check" do 
			it "returns true" do
				chess.board[7][4] = nil
				chess.board[4][3] = King.new("white", [4,3])
				chess.board[6][3] = Rook.new("black", [6,3])
				expect(chess.check?).to be true
			end
		end
		context "diagonal check" do
			it "returns true" do 
				chess.board[7][4] = nil
				chess.board[4][3] = King.new("white", [4,3])
				chess.board[6][5] = Bishop.new("black", [6,5])
				expect(chess.check?).to be true
			end
		end
		context "knight check" do
			it "returns true" do 
				chess.board[7][4] = nil
				chess.board[4][3] = King.new("white", [4,3])
				chess.board[6][4] = Knight.new("black", [6,4])
				expect(chess.check?).to be true
			end
		end
	end

	describe "check_valid_moves" do 
		context "king can move out of horizontal check" do
			it "returns moves" do
			end
		end
		context "king can move out of vertical check" do
			it "returns moves" do
			end
		end
		context "king can move out of diagonal check" do
			it "returns moves" do
			end
		end
		context "king can move out of knight check" do
			it "returns moves" do
			end
		end
	end
end