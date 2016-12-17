
		context "black pawn at 1,0 and given 3,0" do
			it "returns true" do
				pawn = Pawn.new("black", [1,0])
				expect(pawn.valid_move?([3,0])).to be_truthy
			end
		end

		context "black pawn at 1,0 and given 0,0" do
			it "returns false" do
				pawn = Pawn.new("black", [1,0])
				expect(pawn.valid_move?([0,0])).to be_falsey
			end
		end

		context "black pawn at 1,0 and given 1,1" do
			it "returns false" do
				pawn = Pawn.new("black", [1,0])
				expect(pawn.valid_move?([1,1])).to be_falsey
			end
		end

		context "black pawn at 1,0 and given 2,1" do
			it "returns false" do
				pawn = Pawn.new("black", [1,0])
				expect(pawn.valid_move?([2,1])).to be_falsey
			end
		end

		context "white pawn at 6,0 and given 6,0" do
			it "returns true" do
				pawn = Pawn.new("white", [6,0])
				expect(pawn.valid_move?([5,0])).to be_truthy
			end
		end

		context "white pawn at 7,0 and given 5,0" do
			it "returns true" do
				pawn = Pawn.new("white", [6,0])
				expect(pawn.valid_move?([4,0])).to be_truthy
			end
		end

		context "white pawn at 6,0 and given 7,0" do
			it "returns true" do
				pawn = Pawn.new("white", [6,0])
				expect(pawn.valid_move?([7,0])).to be_falsey
			end
		end

		context "white pawn at 6,0 and given 6,1" do
			it "returns true" do
				pawn = Pawn.new("white", [6,0])
				expect(pawn.valid_move?([6,1])).to be_falsey
			end
		end

		context "white pawn at 6,0 and given 5,1" do
			it "returns true" do
				pawn = Pawn.new("white", [6,0])
				expect(pawn.valid_move?([5,1])).to be_falsey
			end
		end