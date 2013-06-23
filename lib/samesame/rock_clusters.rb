require "samesame/cluster_similarity"

module SameSame
  class RockClusters
    attr_accessor :link_matrix, :clusters, :goodness_measure, :cluster_map, :closest_clusters
    
    def initialize( attrs = {} )
      self.link_matrix = attrs.fetch(:link_matrix)
      self.goodness_measure = attrs.fetch(:goodness_measure)
      self.cluster_map = {}
      @last_key = -1

      attrs[:clusters].each {|c| add_cluster(c) }
      calculate_closest_clusters
    end

    def merge_best_candidates
      key1, similarity = find_most_similar_pair
      if key1
        merge_clusters key1, similarity.cluster_key
        similarity.goodness
      end
    end

    def find_most_similar_pair
      closest_clusters.sort_by {|_, similarity| similarity.goodness}.first || []
    end

    def size
      cluster_map.size
    end

    def clusters
      cluster_map.values
    end

    def add_cluster( c )
      cluster_map[next_key] = c
    end

    def next_key
      @last_key = @last_key + 1
    end

    def calculate_closest_clusters
      self.closest_clusters = {}
      cluster_map.each do |cluster_key, cluster|
        similarity = cluster_map.map do |other_key, other_cluster|
          if cluster_key != other_key
            number_of_links = link_matrix.count_links_between_clusters( cluster, other_cluster )
            if number_of_links > 0
              goodness = goodness_measure.g( number_of_links, cluster.size, other_cluster.size)
              ClusterSimilarity.new( other_key, goodness )
            end
          end
        end.compact.sort.first
        closest_clusters[cluster_key] = similarity if similarity
      end
    end

    def merge_clusters(key1, key2)
      merged_key = add_cluster( cluster_map.delete(key1) + cluster_map.delete(key2) )
      calculate_closest_clusters
      merged_key
    end
       
  end
end