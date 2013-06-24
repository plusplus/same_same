require 'same_same'
require 'same_same/dendrogram_printer'
require 'csv'

digg_rows = CSV.read("../spec/fixtures/digg_stories.csv", headers: true)
digg_data = digg_rows.map {|row|
  SameSame::DataPoint.new( row["title"], 
    %w(category topic description).map {|key|
      row[key]
    }.join(" ").downcase.split(/\s+/)
  )
}

distance       = SameSame::CosineDistance.new
vector_builder = SameSame::DbscanTermFrequencyVectors.new
algo = SameSame::DbscanAlgorithm.new(
  points: digg_data,
  eps: 0.7,
  min_points: 2,
  vector_calculator: vector_builder,
  distance: distance)

clusters = algo.cluster

SameSame::DendrogramPrinter.new.print_clusters( clusters )
