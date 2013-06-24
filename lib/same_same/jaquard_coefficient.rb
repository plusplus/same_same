module SameSame
  class JaquardCoefficient
    def similarity( x, y )
      raise(ArgumentError, "both sets cannot be empty") if x.empty? && y.empty?
      return 0.0 if x.empty? || y.empty?
      (x & y).size.to_f / (x | y).size.to_f
    end
  end
end