module SameSame

  class MergeGoodnessMeasure
    attr_reader :th, :p

    # th should be >= 0 and <= 1
    #   0 means all datapoints are neighbours
    #   1 means no datapoints are neighbours
    #   (proximity)
    def initialize( th )
      @th = th
      @p = 1.0 + 2.0 * f( th )
    end

    def g(number_of_links, size_x, size_y)
      a = (size_x + size_y) ** p
      b = size_x ** p
      c = size_x ** p

      number_of_links / (a - b - c)
    end

    private

    def f( th )
      (1.0 - th) / (1.0 + th)
    end
  end

end