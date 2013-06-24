module SameSame
  class DbscanNeighborhood
    # Contains distances between points.
    attr_accessor :adjacency_matrix

    # Threshold value. Determines which points will be considered as
    # neighbors. Two points are neighbors if the distance between them does 
    # not exceed threshold value.
    attr_accessor :eps    

    # used to cache index of points in the matrix
    attr_accessor :index_mapping

    attr_accessor :points

    # Initializes algorithm with all data that it needs.
    # 
    #  * points - points to cluster
    #  * eps - distance threshold value
    #  * minPoints - number of neighbors for point to be considered a core point.
    def initialize(attrs = {})
      self.eps    = attrs.fetch(:eps)
      self.points = attrs.fetch(:points)

      build_index_mapping
      
      vector_calculator    = attrs[:vector_calculator] || DbscanNumericVectors.new
      distance             = attrs.fetch( :distance )
      use_term_frequencies = attrs[:use_term_frequencies] || false

      self.adjacency_matrix = 
            calculate_adjacency_matrix(distance, points, vector_calculator)
    end

    def neighbors_of( p )
      Set.new.tap do |neighbors|
        i = index_mapping[p]
        (0..index_mapping.size-1).each do |j|
          neighbors.add(points[j]) if adjacency_matrix.lookup(i,j) <= eps
        end
      end
    end

    private

    def build_index_mapping
      self.index_mapping = {}
      points.each_with_index do |p,i|
        index_mapping[p] = i
      end
      index_mapping
    end

    def calculate_adjacency_matrix(distance, points, vector_calculator)
      SymmetricalMatrix.new( points.size ).tap do |m|
        (0..points.size - 1).each do |i|
          m.set(i,i, 0.0)
          ((i+1)..(points.size - 1)).each do |j|
            x, y = vector_calculator.vectors( points[i], points[j] )
            d = distance.distance(x, y)
            m.set(i,j,d)
          end
        end
      end
    end

  end
end