require "samesame/dendrogram"
require "samesame/link_matrix"
require "samesame/merge_goodness_measure"
require "samesame/rock_clusters"
require "samesame/similarity_matrix"

module SameSame
  class RockAlgorithm
    attr_accessor :datapoints, :similarity_measure, :k, :th, :link_matrix, :similarity_matrix

    def initialize( attrs = {} )
      self.datapoints         = attrs.fetch( :datapoints )
      self.similarity_measure = attrs[ :similarity_measure ] || JaquardCoefficient.new
      self.k                  = attrs.fetch(:k)
      self.th                 = attrs.fetch(:th)

      self.similarity_matrix  = SimilarityMatrix.new( similarity_measure, datapoints.map {|d| d.data} )
      self.link_matrix        = LinkMatrix.new( datapoints: datapoints, similarity_matrix: similarity_matrix, th: th)
    end

    def cluster
      Dendrogram.new( "Goodness" ).tap do |dnd|
        initial_clusters = one_point_per_cluster
        g = Float::INFINITY
        dnd.add_level(g.to_s, initial_clusters)
        goodness = MergeGoodnessMeasure.new( th )

        rock_clusters = RockClusters.new(
          link_matrix:      link_matrix,
          clusters:         initial_clusters,
          goodness_measure: goodness)

        number_of_clusters = rock_clusters.size
        while number_of_clusters > k do
          number_of_clusters_before_merge = number_of_clusters
          g = rock_clusters.merge_best_candidates
          number_of_clusters = rock_clusters.size
          
          # finish if there are no linked clusters to merge
          break if number_of_clusters == number_of_clusters_before_merge

          dnd.add_level(g.to_s, rock_clusters.clusters)
        end
      end
    end

    def one_point_per_cluster
      datapoints.map {|point| Cluster.new([point])}
    end
  end
end