#! /bin/env ruby

if ARGV.size < 1
  puts "Usage:\n\t ./speck.rb 'COMMAND' file1 file2 ...\n\n"
  puts "The command string is a string of space-separated one letter long commands\n"
  puts "followed by an optional comma-separated list of options:\n"
  puts "\t s[comma-sep-opts]     :  ./scarlet.rb [opts] file1 file2 ..."
  puts "\t t                     :  ./table-from-moss.rb"
  puts "\t f[comma-sep-opts]     :  ./filter.rb [opts]"
  puts "\t h                     :  ./shorten.rb"
  puts "\t a                     :  ./anonymize.rb"
  puts "\t m[comma-sep-opts]     :  ./make-dot.rb [opts]"
  puts "\t d[outfile]            :  dot -T[outfile-extension] -o[outfile]\n\n"
  puts "Example 1:\n\t ./speck.rb 's h m dresult.pdf' *.py"
  puts "   => \t ./scarlet.rb *.py | ./shorten.rb | /make-dot.rb | dot -Tpdf -o result.pdf"
  puts "\n"
  puts "Example 2:\n\t ./speck.rb 's fexample.cpp,0.7 h a m0.7,3 dout.pdf' file1.cpp file2.cpp file3.cpp"
  puts "   => \t ./scarlet.rb file1.cpp file2.cpp file3.cpp | ./filter.rb example.cpp 0.7 | ./shorten.rb | ./anonymize.rb | ./make-dot.rb 0.7 3 | dot -Tpdf -o out.pdf"
  puts "\n"
  puts "Example 3:\n\t cat moss-file.html | ./speck.rb 't h a m0.75,6 dout.pdf'"
  puts "   => \t cat moss-file.html | ./table-from-moss.rb | ./shorten.rb | ./anonymize.rb | ./make-dot.rb 0.75 6 | dot -Tpdf -o out.pdf"
  puts "\n"
  exit(1)
end

cmd = ARGV[0]
files = ARGV[1..-1]

cmd_array = []

cmd.split.each{|s|
  c = s[0].downcase
  rest = s[1..-1]
  case c 
  when 's'
    cmd_array << "./scarlet.rb #{rest.split(',').join(' ')} #{files.join(' ')}"
  when 't'
    cmd_array << "./table-from-moss.rb"
  when 'f'
    cmd_array << "./filter.rb #{rest.split(',').join(' ')}"
  when 'h'
    cmd_array << "./shorten.rb"
  when 'a'
    cmd_array << "./anonymize.rb"
  when 'm'
    cmd_array << "./make-dot.rb #{rest.split(',').join(' ')}"
  when 'd'
    cmd_array << "dot -T#{File.extname(rest).gsub('.','')} -o#{rest}"
  end
}

system(cmd_array.join(' | '))
