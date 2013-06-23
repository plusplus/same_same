require 'samesame/cosine_similarity'

module SameSame
  class CosineDistance

    attr_accessor :cosin

    def initialize
      self.cosin = CosineSimilarity.new
    end

    def distance(x, y)
      sim = cosin.sim(x, y)

      if sim < 0.0
        throw new ArgumentError(
                "Can't use this value to calculate distance." +
                "x[]=" + x.inspect + 
                ", y[]=" + y.inspect +
                ", cosin.sim(x,y)=" + sim)
      end

      1.0 - sim
    end
  end

end