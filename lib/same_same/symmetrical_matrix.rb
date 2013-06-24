module SameSame
  class SymmetricalMatrix
    attr_reader :size, :lookup_proc

    def initialize( size, lookup_proc = nil )
      @size = size
      @lookup_proc = lookup_proc
      @matrix = []
    end

    def set(x,y,v)
      check_bounds(x,y)
      matrix[x * size + y] = matrix[y * size + x] = v
    end

    def lookup(x,y)
      check_bounds(x,y)
      if matrix[x * size + y].nil?
        if block_given?
          set(x,y, yield(x,y))
        elsif lookup_proc
          set(x,y, lookup_proc.call(x,y))
        end
      end
      matrix[x * size + y]
    end

    private

    def check_bounds(x,y)
      raise ArgumentError.new( "nil index" ) if x.nil? || y.nil?
      raise ArgumentError.new( "out of bounds" ) if (x < 0 || x >= size) || (y < 0 || y >= size)
    end

    def matrix
      @matrix
    end
  end
end
