require 'same_same'

describe SameSame::JaquardCoefficient do

  describe '#similarity' do
    it "raises ArgumentError if both sets are empty" do
      expect {subject.similarity([],[])}.to raise_error(ArgumentError)
    end

    it "is 0 if either set is empty" do
      expect(subject.similarity([],["yolo"])).to eq(0.0)
      expect(subject.similarity(["yolo"],[])).to eq(0.0)
    end

    it "is 1.0 for identical sets" do
      expect( subject.similarity(["yolo"], ["yolo"]) ).to eq(1.0)
      expect( subject.similarity(["yolo", "oloy"], ["yolo", "oloy"]) ).to eq(1.0)
    end

    it "is 1/3 for 1 common element and 3 total" do
      expect( subject.similarity(["yolo", "polo"], ["yolo", "oloy"]) ).to eq(1.0 / 3.0)
    end
  end
end
