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


k = 2
th = 0.2
algo = SameSame::RockAlgorithm.new(datapoints: digg_data, k: k, th: th)
dnd = algo.cluster

SameSame::DendrogramPrinter.new.print_last(dnd)
