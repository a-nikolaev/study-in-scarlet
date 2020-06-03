#! /usr/bin/env ruby

# Shortens filenames (column 1 and 2) by removing their common prefix and common suffix.
#
# Usage:
#   
#   cat table | ./shorten.rb 

require 'set'

# Length of the longest common prefix
def len_of_prefix(ls)
  if ls.size == 0
    0
  else
    min, max = ls.minmax
    i = 0
    while min[i] != nil && min[i] == max[i]
      i += 1
    end
    i
  end
end

def len_of_suffix(ls)
  len_of_prefix(ls.map{|s| s.reverse})
end

# Read STDIN and find common prefix and suffix of the filenames (ids)

lines = Array.new
full_ids = Set.new
STDIN.each_line{|line|
  arr = line.split() 
  if arr.size > 2
    full_ids << arr[0]
    full_ids << arr[1]
    lines << arr
  end
}
prefix_len = len_of_prefix(full_ids)
suffix_len = len_of_suffix(full_ids)

def short(s, l, r) 
  s[l ... (s.size - r)]
end

lines.each{|arr|
  arr[0] = short(arr[0], prefix_len, suffix_len)
  arr[1] = short(arr[1], prefix_len, suffix_len)
  puts arr.join(' ')
}
