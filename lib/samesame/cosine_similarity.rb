module SameSame

  class CosineSimilarity

    def similarity(x, y)
      sim(*TermFrequencyBuilder.build_vectors( x.data, y.data ))
    end

    def sim(v1, v2)
      dot_product(v1, v2) / (norm(v1) * norm(v2))
    end
    
    def dot_product(v1, v2)
      v1.zip(v2).map {|val1,val2| val1 * val2}.inject(:+)
    end

    def norm(vector)
      Math.sqrt( vector.map {|val| val ** 2}.inject(:+) )
    end
  end

end