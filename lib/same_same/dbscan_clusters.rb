require 'set'

module SameSame
  class DbscanClusters

    # Identifies a set of Noise points.
    NOISE_ID = -1    
    
    # Identifies a set of Unclassified points.
    UNCLASSIFIED_ID = 0


    attr_accessor :clusters, :last_id

    def initialize( unclassified )
      self.clusters = Hash.new {|hash, key|
        hash[key] = Set.new
      }
      self.last_id = 0
      assign_points( unclassified, UNCLASSIFIED_ID )
    end

    def assign_to_noise( p )
      assign_point( p, NOISE_ID)
    end

    def unclassified?(p)
      point_in_cluster?(p, UNCLASSIFIED_ID)
    end
    
    def noise?(p)
      point_in_cluster?(p, NOISE_ID)
    end
    
    def point_in_cluster?( p, cluster_id)
      clusters[cluster_id].include?( p )
    end
    
    def assign_points(points, cluster_id)
      points.each {|p| assign_point( p, cluster_id)}
    end
    
    def assign_point( p, cluster_id)
      # Remove point from the group that it currently belongs to...
      if noise?(p)
        remove_point_from_cluster(p, NOISE_ID)
      elsif unclassified?(p)
        remove_point_from_cluster(p, UNCLASSIFIED_ID)
      else
        if cluster_id != UNCLASSIFIED_ID
          raise ArgumentError.new("Trying to move point that has already been assigned to some other cluster. Point: #{p}, cluster_id=#{cluster_id}")
        end
      end
      
      clusters[cluster_id] << p
    end

    def to_clusters
      [].tap do |all_clusters|       
        clusters.each do |id, points|
          all_clusters << Cluster.new(points, cluster_name(id)) unless points.empty?
        end
      end
    end


    def cluster_name(id)
      case id
      when NOISE_ID then "Noise"
      when UNCLASSIFIED_ID then "Unclassified"
      else "Cluster #{id}"
      end
    end

    def remove_point_from_cluster(p, cluster_id)
      cluster = clusters[cluster_id]

      return false if cluster.nil?
      cluster.include?(p).tap do
        cluster.delete p
      end
    end
    
    def get_next_cluster_id
      self.last_id = last_id + 1
    end
  end
end