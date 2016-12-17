require "chess_board"
require "pieces"

describe ChessBoard do
	
	let(:cb) {ChessBoard.new()}
	let(:initial) {"\n\n" \
				   " ♖   ♘   ♗   ♕   ♔   ♗   ♘   ♖   8\n" \
				   " ♙   ♙   ♙   ♙   ♙   ♙   ♙   ♙   7\n" \
				   " *   *   *   *   *   *   *   *   6\n" \
				   " *   *   *   *   *   *   *   *   5\n" \
				   " *   *   *   *   *   *   *   *   4\n" \
				   " *   *   *   *   *   *   *   *   3\n" \
				   " ♟   ♟   ♟   ♟   ♟   ♟   ♟   ♟   2\n" \
				   " ♜   ♞   ♝   ♛   ♚   ♝   ♞   ♜   1\n\n" \
				   " A   B   C   D   E   F   G   H\n\n"}

	describe "initialize" do
		it "creates the board and sets up the pieces" do
			(0..1).each do |i|
				cb[i].each do |col|
					expect(col).to be_kind_of(Piece)
				end
			end

			(6..7).each do |i|
				cb[i].each do |col|
					expect(col).to be_kind_of(Piece)
				end
			end
		end
	end

	describe "format_board" do
		context "with initial board" do
			it "returns the display of intial setup" do
				expect(cb.format_board).to eql(initial)
			end
		end
	end

end