module SameSame
  class DataPoint < Struct.new( :id, :data )
    def empty?
      data.empty?
    end

    def size
      data.size
    end

  end
end