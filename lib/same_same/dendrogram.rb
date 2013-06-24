module SameSame

  class Dendrogram

    Level = Struct.new(:name, :clusters)

    attr_accessor :levels, :level_label

    def initialize(name)
      self.levels = []
      self.level_label = name
    end

    def add_level( name, clusters )
      self.levels << Level.new(name, clusters.map(&:dup))
    end

    def [](i)
      levels[i]
    end

    def non_singelton_leaves?
      levels.last.clusters.any? {|cluster| cluster.size > 1}
    end

  end

end