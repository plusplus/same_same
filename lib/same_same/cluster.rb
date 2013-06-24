module SameSame
  class Cluster
    # note to self - unless I need to implement a heap
    # more, i'm just wrapping an array and delegating...
    attr_accessor :datapoints, :name

    def initialize( dp, name = nil )
      self.datapoints = dp
      self.name = name
    end

    def +( other )
      names = [name, other.name].compact
      new_name = names.empty? ? nil : names.join("+")
      Cluster.new( datapoints + other.datapoints, new_name )
    end

    def size
      datapoints.size
    end

    def inject(i, &block)
      datapoints.inject(i, &block)
    end

  end
end