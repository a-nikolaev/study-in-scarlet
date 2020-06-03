#! /bin/env ruby

# Converts HTML report produced by MOSS into a Scarlet-like table according to the format:
#
#   filename1  filename2  percent1  percent2  commonlines  max(percent1,percent2)
#
# One can use column 6 (the maximum of two percentages) as the similarity score.
# Usage:
#   
#   cat moss-output.html | ./table-from-moss.rb 

STDIN.each_line('<TR>'){|s| 
  if s.include?('<TD>')
    t = s.split(/<TD[^>]*>/).map{|e| e.gsub(/<\/TABLE>.*/m,'').gsub(/<[^>]*>/, '').strip }.join(' ')
    
    arr = t.split
    
    id1 = arr[0]
    id2 = arr[2]
    pct1 = (arr[1].gsub(/[%()]/,'').to_i * 0.01).round(5)
    pct2 = (arr[3].gsub(/[%()]/,'').to_i * 0.01).round(5)
    num = arr[4].to_i
    
    puts "#{id1} #{id2} #{pct1} #{pct2} #{num} #{[pct1,pct2].max}"
  end
}
