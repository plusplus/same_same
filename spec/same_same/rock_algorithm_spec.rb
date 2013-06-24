require 'csv'
require 'same_same'
require 'same_same/dendrogram_printer'

describe SameSame::RockAlgorithm do
  let(:dp1) {["book"]}
  let(:dp2) {["water", "sun", "sand", "swim"]}
  let(:dp3) {["water", "sun", "swim", "read"]}
  let(:dp4) {["read", "sand"]}
  let(:points) {[dp1, dp2, dp3, dp4].map {|data| SameSame::DataPoint.new(data.join("-"), data)}}
  let(:digg_data) {
    digg_data = CSV.read("spec/fixtures/digg_stories.csv", headers: true)
    digg_data.map {|row|
      SameSame::DataPoint.new( row["title"], 
        %w(category topic description).map {|key|
          row[key]
        }.join(" ").downcase.split(/\s+/)
      )
    }
  }

  let(:line_data) {
    csv = CSV.read("spec/fixtures/lines.csv", headers: true)

    groups = csv.group_by {|csv| [csv['categories'], csv['price']].join("-")}

    groups.map {|key, group|
      [key, group.map {|row|
        SameSame::DataPoint.new( [row["id"], row["name"]].map {|t| t.gsub(/\s+/, ' ')}.join(": "), 
          %w(name price price price price categories).map {|key|
            row[key]
          }.join(" ").downcase.split(/\s+/) + [row["name"].downcase.gsub(/\s+/, ' ')]
        )
      }]
    }
  }

  # it "works" do
  #   k = 2
  #   th = 0.2
  #   algo = SameSame::RockAlgorithm.new(datapoints: points, k: k, th: th)
  #   dnd = algo.cluster

  #   SameSame::DendrogramPrinter.new.print(dnd)
  # end



  it "works on the digg data" do
    k = 2
    th = 0.2
    algo = SameSame::RockAlgorithm.new(datapoints: digg_data, k: k, th: th)
    dnd = algo.cluster

    #SameSame::DendrogramPrinter.new.print_last(dnd)
  end

  it "works on lines" do
    k = 4
    th = 0.4
    line_data.each do |key, group|
      if group.size > 1
        algo = SameSame::RockAlgorithm.new(datapoints: group, k: k, th: th)
        dnd = algo.cluster
        if dnd.non_singelton_leaves?
          #SameSame::DendrogramPrinter.new.print_last(dnd)
        end
      end
    end
  end
end