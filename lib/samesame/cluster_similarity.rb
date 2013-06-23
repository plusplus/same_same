module SameSame

  class ClusterSimilarity < Struct.new( :cluster_key, :goodness )
    include Comparable
    def <=>(other)
      goodness <=> other.goodness
    end
  end

end