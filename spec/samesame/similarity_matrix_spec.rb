require 'samesame'

describe SameSame::SimilarityMatrix do
  let(:measure) {double("Measure")}
  let(:datapoints) {[1,2,3]}

  subject {SameSame::SimilarityMatrix.new( measure, datapoints )}
  
  describe "#[]" do
    it "returns 1.0 without calculation for self similarity" do
      expect( subject.lookup 1,1 ).to eq(1.0)
    end

    it "calculates simlarity for different datapoints" do
      measure.should_receive( :similarity ).with( 2, 3 ).and_return 2.0
      expect( subject.lookup 1,2 ).to eq(2.0)
    end

  end
end