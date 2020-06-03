#! /bin/env ruby

# Eliminates files that are similar to a given file (i.e. an example program, similarity with which
# does not constitute plagiarism).
# 
# Usage:
#
#   cat table | ./filter.rb [pattern] [threshold=0.7] [column=3]
#
# It removes all files whose similarity score with the given file "pattern" exceeds the given threshold. 
# The third argument determines which column contain the similarity score (indexing starts with 1). 
# If the column number or threshold are not supplied, their default values are 3 and 0.7.
#
# Pattern may contain a partial filename (e.g. 'philipps' instead of 'bob-philipps-program.cpp'). 
# Such partial pattern is accepted as long as it uniquely identifies the target filename.
#
# Examples:
#   
#   cat table | ./filter.rb example.cpp 0.8 
#   cat table | ./filter.rb example.cpp 0.8 3 
#   cat table | ./filter.rb example 0.8 3 

require 'set'

nbrs_of_excluded = Set.new

ex_partial_id = nil
ex_full_id = nil
threshold = 0.7
column = 3

if ARGV.size > 0
  ex_partial_id = ARGV[0]
end

if ARGV.size > 1
  threshold = ARGV[1].to_f
end

if ARGV.size > 2 
  column = ARGV[2].to_i
end

data = Hash.new

STDIN.each_line{|line|
  arr = line.split()
  id1 = arr[0]
  id2 = arr[1]
  score = arr[column-1].to_f
  data[[id1, id2]] = line

  if ex_partial_id == nil
    next
  end

  # apply exclusion rule
  if id1.include?(ex_partial_id)
    if ex_full_id == nil
      ex_full_id = id1
      nbrs_of_excluded << id1
    elsif ex_full_id != id1
      STDERR.puts "filter-nbrs.rb: Error: Multiple files for pattern '#{ex_partial_id}'"
      exit(1)
    end
    if score >= threshold
      nbrs_of_excluded << id2      
    end
  end
  
  if id2.include?(ex_partial_id)
    if ex_full_id == nil
      ex_full_id = id2
      nbrs_of_excluded << id2
    elsif ex_full_id != id2
      STDERR.puts "filter-nbrs.rb: Error: Multiple files for pattern '#{ex_partial_id}'"
      exit(1)
    end
    if score >= threshold
      nbrs_of_excluded << id1      
    end
  end

}

data.each_key{|key| 
  id1 = key[0]
  id2 = key[1]
  if ! (nbrs_of_excluded.member?(id1) || nbrs_of_excluded.member?(id2))
    puts "#{data[key]}"
  end
}

