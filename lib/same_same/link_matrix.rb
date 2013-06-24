module SameSame
  class LinkMatrix
    attr_reader :links, :index_lookup

    def initialize( attrs = {} )
      similarity_matrix = attrs.fetch(:similarity_matrix)
      datapoints        = attrs.fetch(:datapoints)
      th                = attrs.fetch(:th)
      neighbours        = calculate_neighbours( datapoints, similarity_matrix, th )

      @links             = calculate_links( neighbours, datapoints )
      @index_lookup      = calculate_index_lookup( datapoints )
    end

    def count_links_between_clusters( cluster1, cluster2 )
      cluster1.inject(0) do |sum, p1|
        cluster2.inject(sum) do |sum2, p2|
          sum2 + number_of_links_between_points(p1, p2)
        end
      end
    end

    def number_of_links_between_points( datapoint1, datapoint2 )
      links.lookup( index_lookup[datapoint1], index_lookup[datapoint2] )
    end

    private

    def calculate_index_lookup( datapoints )
      {}.tap do |index|
        datapoints.each_with_index {|p, i| index[p] = i}
      end
    end

    def calculate_links( neighbours, datapoints )
      SymmetricalMatrix.new(
        neighbours.size,
        ->(x,y) {number_of_links(neighbours, datapoints, x, y)}
      )
    end

    def calculate_neighbours( datapoints, similarity_matrix, th )
      SymmetricalMatrix.new(
        datapoints.size,
         ->(x,y) {similarity_matrix.lookup(x,y) >= th ? 1 : 0}
      )
    end

    #     0  1  2  3
    #   ------------
    # 0 | Y  -  Y  -
    # 1 | -  Y  -  -
    # 2 | -  -  -  -
    # 3 | -  Y  -  -
    #
    def number_of_links(neighbors, datapoints, x, y)
      (0..datapoints.size-1).map do |i|
        neighbors.lookup(x,i) * neighbors.lookup(i,y)
      end.inject(0) {|m,v| m+v}
    end
  end
end