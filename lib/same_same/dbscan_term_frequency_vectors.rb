module SameSame
  class DbscanTermFrequencyVectors
    def vectors(p1, p2)
      TermFrequencyBuilder.build_vectors( p1.data, p2.data )
    end
  end
end