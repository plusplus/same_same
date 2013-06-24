require 'same_same'
require 'same_same/dendrogram_printer'
require 'csv'

csv = CSV.read("../spec/fixtures/lines.csv", headers: true)

# , row['price']
groups = csv.group_by {|row| [row['categories']].join("-")}

fragments = groups.map {|group_key, group|
  [group_key, group.map {|row|
    SameSame::DataPoint.new( [row["id"], row["name"]].map {|t| t.gsub(/\s+/, ' ')}.join(": "), 
      %w(name price).map {|key|
        row[key]
      }.join(" ").downcase.split(/\s+/)
    )
  }]
}

distance       = SameSame::CosineDistance.new
vector_builder = SameSame::DbscanTermFrequencyVectors.new

fragments.each do |key, group|
  if group.size > 1
    algo = SameSame::DbscanAlgorithm.new(
      points: group,
      eps: 0.3,
      min_points: 2,
      vector_calculator: vector_builder,
      distance: distance)

    clusters = algo.cluster
    SameSame::DendrogramPrinter.new.print_clusters( clusters.select {|c| c.name != "Noise"} )
  end
end
