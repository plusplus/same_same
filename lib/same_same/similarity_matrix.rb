module SameSame
  class SimilarityMatrix
    attr_reader :matrix, :measure, :datapoints

    def initialize( measure, datapoints )
      @matrix     = SymmetricalMatrix.new( datapoints.size )
      @measure    = measure
      @datapoints = datapoints
    end

    def lookup(i,j)
      return 1.0 if i == j
      matrix.lookup(i,j) do |x,y|
        measure.similarity( datapoints[x], datapoints[y])
      end
    end

  end

end
