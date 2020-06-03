#! /bin/env ruby

# Produces a .dot (Graphviz) file from a similarity table
#
# Usage:
#
#   cat table | ./make-dot.rb [threshold=0.7] [column=3]
#
# Threshold determines the minimum similarity score for an edge to be displayed.
# Column tells which column contains the similarity score (indexing starts with 1).
# If column is not supplied, it's assumed to be 3.
# If threshold is not supplied, it's assumed to be 0.7.
#
# Example 1 (with Scarlet):
#   
#   ./scarlet.rb path/*.cpp | ./make-dot.rb 0.6 3 | dot -Tpdf -o oputput.pdf
#
# Example 2 (with MOSS):
#   
#   cat moss-output.html | ./table-from-moss.rb | ./make-dot.rb 0.8 6 | dot -Tpdf -o oputput.pdf
#

threshold = 0.7    # default threshold
if ARGV.size >= 1
  threshold = ARGV[0].to_f
end

column = 3         # default column (1, 2, 3, ...)
if ARGV.size >= 2
  column = ARGV[1].to_i
end

puts "graph {"
puts "  node [fontname = \"sans\"];"                    
puts "  edge [fontname = \"sans\", fontsize = \"12\"];"

weight = Hash.new(0)
max_weight = 0

STDIN.each_line{|line|
  words = line.split()
  if words.size > 0 
    id1 = words[0]
    id2 = words[1]
    sim = words[column-1].to_f

    if sim >= threshold
      sm = (sim - threshold) / (1-threshold) # 1 = similar, 0 = different
    
      weight[id1] += sm
      weight[id2] += sm
      max_weight = [max_weight, weight[id1], weight[id2]].max
      
      h = 0.5 + 0.5*sm
      s = 0.5 + 0.5*sm
      v = 0.5 + 0.5*sm
      color = "\"#{h} #{s} #{v}\""

      penwidth = [0.5 + sm * 3.5, 4].min
      puts "\"#{id1}\" -- \"#{id2}\" [label=\"#{(100*sim).round}\", fontcolor=#{color}, color=#{color}, penwidth=#{penwidth}];"
    end
  end
}

weight.each_pair{|id, wgt|
  bad = wgt / max_weight
  h = 0.5 + 0.5*bad
  s = 0.5 + 0.5*bad
  v = 0.5 + 0.5*bad
  color = "\"#{h} #{s} #{v}\""
  puts "\"#{id}\" [penwidth=#{0.5 + 3.5*bad}, color=#{color}]"
}

puts "}"
