require 'same_same'
require 'same_same/dendrogram_printer'
require 'csv'

csv = CSV.read("../spec/fixtures/lines.csv", headers: true)

groups = csv.group_by {|row| [row['categories'], row['price']].join("-")}

fragments = groups.map {|group_key, group|
  [group_key, group.map {|row|
    SameSame::DataPoint.new( [row["id"], row["name"]].map {|t| t.gsub(/\s+/, ' ')}.join(": "), 
      %w(name price categories).map {|key|
        row[key]
      }.join(" ").downcase.split(/\s+/) + [row["name"].downcase.gsub(/\s+/, ' ')]
    )
  }]
}

k = 4
th = 0.4
fragments.each do |key, group|
  if group.size > 1
    algo = SameSame::RockAlgorithm.new(datapoints: group, k: k, th: th)
    dnd = algo.cluster
    if dnd.non_singelton_leaves?
      SameSame::DendrogramPrinter.new.print_last(dnd)
    end
  end
end


