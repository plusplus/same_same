require 'colored'

module SameSame

  class DendrogramPrinter

    def print_last(dnd)
      level = dnd.levels.last
      print_clusters( level.clusters )
    end

    def print_clusters(clusters)
      clusters.each do |cluster|
        if cluster.size > 1
          puts "## #{cluster.name}" if cluster.name
          print_points( cluster.datapoints )
        end
      end
    end

    def print(dnd)
      dnd.levels.each_with_index do |level, i|
        single_point_clusters = level.clusters.select {|cluster| cluster.size == 1}
        ungrouped = single_point_clusters.map {|c| c.datapoints}.flatten
        
        puts
        puts "-" * 80
        puts "#{dnd.level_label}: #{level.name}"
        puts
        puts "Clusters: #{level.clusters.size - single_point_clusters.size}"
        puts "Ungrouped: #{ungrouped.size}"
        puts "-" * 80
        puts
        
        level.clusters.each do |cluster|
          if cluster.size > 1
            print_points( cluster.datapoints )
          end
        end
        puts


        if i == dnd.levels.size - 1
          puts "FINAL UNGROUPED"
          print_points(ungrouped)
        end
      end
    end

    def highlight_common( content, common_words )
      words = content.strip.split(/\s+/)
      words.map {|word| common_words.include?(word.downcase) ? word : word.bold.red}.join(" ")
    end

    def formatted_datapoint_name( content, common_words )
      if content =~ /^(\d+:)(.*)/
        "#{$1.cyan} #{highlight_common( $2, common_words) }"
      else
        highlight_common( content, common_words )
      end
    end

    def print_points(datapoints)
      puts
      all_terms = datapoints.map(&:id).map(&:downcase).map {|id| id.split(/\s+/)}
      common_words = all_terms.inject(all_terms.flatten.uniq) {|m,v| m & v}
      datapoints.sort_by {|dp| dp.id.gsub(/^\d+:/, '')}.each do |dp|
        puts formatted_datapoint_name( dp.id, common_words )
      end
      puts
    end
  end

end