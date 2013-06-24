require 'same_same/dbscan_neighborhood'
require 'same_same/dbscan_clusters'

module SameSame

  # Implementation of DBSCAN clustering algorithm. 
  # 
  # Algorithm parameters:
  # 
  #  * Eps - threshold value to determine point neighbors. Two points are 
  #    neighbors if the distance between them does not exceed this threshold value. 
  #  * MinPts - minimum number of points in any cluster.
  #
  # Choice of parameter values depends on the data.
  #
  # Point types:
  #
  #   * Core point - point that belongs to the core of the cluster. It has at least
  #     MinPts neighboring points.
  #   * Border point - is a neighbor to at least one core point but it doesn't 
  #     have enough neighbors to be a core point.
  #   * Noise point - is a point that doesn't belong to any cluster because it is
  #     not close to any of the core points.
  #
  class DbscanAlgorithm
    attr_accessor :points

    # Sets of points. Initially all points will be assigned into 
    # Unclassified points set.
    attr_accessor :dbscan_clusters
    
    # Number of points that should exist in the neighborhood for a point
    # to be a core point.
    #
    # Best value for this parameter depends on the data set.
    attr_accessor :min_points
    
    attr_accessor :neighborhood
    

    # Initializes algorithm with all data that it needs.
    # 
    #  * points            - points to cluster
    #  * eps               - distance threshold value
    #  * min_points        - number of neighbors for point to be considered a
    #                        core point.
    #  * distance          - distance measure to use (defaults to Cosine)
    #  * vector_calculator - calculates the vectors to use for distance comparison.
    #                        defaults to DbscanNumericVectors which compares just
    #                        the numeric attributes of the datapoint.
    #                        Alternatively use DbscanTermFrequency.
    def initialize(attrs = {})
      self.points       = attrs.fetch(:points)
      self.min_points   = attrs.fetch(:min_points)
      distance          = attrs[:distance] || CosineDistance.new
      vector_calculator = attrs[:vector_calculator] || DbscanNumericVectors.new
      
      self.neighborhood = DbscanNeighborhood.new( distance: distance,
                                                  eps: attrs.fetch(:eps),
                                                  points: points,
                                                  vector_calculator: vector_calculator )

      # all points start as unclassifed
      self.dbscan_clusters     = DbscanClusters.new( points )
    end

    def cluster
      cluster_id = dbscan_clusters.get_next_cluster_id
      points.each do |p|
        if dbscan_clusters.unclassified?(p)
          if create_cluster(p, cluster_id)
            cluster_id = dbscan_clusters.get_next_cluster_id
          end
        end
      end
      
      dbscan_clusters.to_clusters
    end


    def create_cluster( p, cluster_id)
      neighbors = neighborhood.neighbors_of p
      if neighbors.size < min_points
        # Assign point into "Noise" group. 
        # It will have a chance to become a border point later on.
        dbscan_clusters.assign_to_noise(p)
        # return false to indicate that we didn't create any cluster
        return false
      end

      # All points are reachable from the core point...
      dbscan_clusters.assign_points(neighbors, cluster_id)
      
      # Remove point itself.
      neighbors.delete(p)
      
      # Process the rest of the neighbors...
      while !neighbors.empty?
        # pick the first neighbor
        neighbor = neighbors.first
        
        # process neighbor
        neighbors_neighbors = neighborhood.neighbors_of neighbor
                
        if neighbors_neighbors.size < min_points
          # do nothing. The neighbor is just a border point.
        else      
          # neighbor is another core point.  
          neighbors_neighbors.each do |neighbors_neighbor|
          
            if dbscan_clusters.noise?(neighbors_neighbor)
              # It's a border point. We know that it doesn't have 
              # enough neighbors to be a core point. Just add it 
              # to the cluster.
              dbscan_clusters.assign_point(neighbors_neighbor, cluster_id)
            elsif dbscan_clusters.unclassified?(neighbors_neighbor)
              
              # We don't know if this point has enough neighbors
              # to be a core point... add it to the list of points
              # to be checked.
              neighbors.add(neighbors_neighbor)
                
              # And assign it to the cluster
              dbscan_clusters.assign_point(neighbors_neighbor, cluster_id)
            end
          end
        end
        
        neighbors.delete neighbor
      end
      true
    end
  
  end
end
