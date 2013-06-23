module SameSame
  class TermFrequencyBuilder

    def self.build_vectors( x, y )
      all_attributes = {}
      x.each {|s| all_attributes[s] = 0x01}
      y.each {|s| all_attributes[s] = (all_attributes[s] || 0x00) | 0x02 }

      # create term frequency vectors
      term_freq_for_x = []
      term_freq_for_y = []
      all_attributes.each {|_, flags|
        term_freq_for_x << (flags & 0x01)
        term_freq_for_y << (flags >> 1)
      }
      [term_freq_for_x, term_freq_for_y]
    end

  end
end
