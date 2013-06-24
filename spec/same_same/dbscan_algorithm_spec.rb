require 'csv'
require 'same_same'
require 'same_same/dendrogram_printer'

# WARNING: This is just really testing that they don't blow up.
describe SameSame::RockAlgorithm do
  let(:digg_data) {
    digg_data = CSV.read("spec/fixtures/digg_stories.csv", headers: true)
    i = 0
    digg_data.map {|row|
      i = i + 1
      SameSame::DataPoint.new( "#{i}: #{row["title"]}", 
        %w(title category topic description).map {|key|
          row[key]
        }.join(" ").downcase.split(/\s+/).select {|w| w.size > 3}
      )
    }
  }

  let(:line_data) {
    csv = CSV.read("spec/fixtures/lines.csv", headers: true)

    # , csv['price']
    groups = csv.group_by {|csv| [csv['categories']].join("-")}

    groups.map {|key, group|
      [key, group.map {|row|
        SameSame::DataPoint.new( [row["id"], row["name"]].map {|t| t.gsub(/\s+/, ' ')}.join(": "), 
          %w(name price).map {|key|
            row[key]
          }.join(" ").downcase.split(/\s+/)
        )
      }]
    }
  }

  it "works on the digg data" do
    distance       = SameSame::CosineDistance.new
    vector_builder = SameSame::DbscanTermFrequencyVectors.new
    
    algo = SameSame::DbscanAlgorithm.new(
      points: digg_data,
      eps: 0.7,
      min_points: 2,
      vector_calculator: vector_builder,
      distance: distance)

    clusters = algo.cluster

    #SameSame::DendrogramPrinter.new.print_clusters( clusters )
  end

  it "works on lines" do
    distance       = SameSame::CosineDistance.new
    vector_builder = SameSame::DbscanTermFrequencyVectors.new

    line_data.each do |key, group|
      if group.size > 1
        algo = SameSame::DbscanAlgorithm.new(
          points: group,
          eps: 0.3,
          min_points: 2,
          vector_calculator: vector_builder,
          distance: distance)

        clusters = algo.cluster
        #expect(clusters.size).to be > 1
        #SameSame::DendrogramPrinter.new.print_clusters( clusters.select {|c| c.name != "Noise"} )
      end
    end
  end
end