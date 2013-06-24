require 'same_same'

describe SameSame::LinkMatrix do
  let( :datapoints ) {(0..19).to_a}
  let( :similarity_matrix ) {
    SameSame::SymmetricalMatrix.new(datapoints.size).tap do |m|
      datapoints.each do |i|
        m.set(i,i,1.0)
      end
      (0..datapoints.size-1).each do |i|
        (0..i-1).each do |j|
          m.set(i,j,(i+j)/40.0)
        end
      end
    end
  }
  let( :th ) {0.2}

  subject {SameSame::LinkMatrix.new(similarity_matrix: similarity_matrix, datapoints: datapoints, th: th)}

  describe "#number_of_links_between_points" do
    it "returns a number" do
      # WARNING: I don't know if these numbers are right!!!!
      expect( subject.number_of_links_between_points(0,1) ).to eq(12)
      expect( subject.number_of_links_between_points(1,2) ).to eq(13)
      expect( subject.number_of_links_between_points(19,19) ).to eq(20)
    end
  end
end