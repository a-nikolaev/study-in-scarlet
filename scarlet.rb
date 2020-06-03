#! /usr/bin/env ruby

# Computes the similarity score between every pair of passed source code files.
# The program tokenizes each file with lexer Rouge, and then uses Sherlock
# to compute the difference between these tokenized files.
#
# Usage:
#
#   ./scarlet.rb [-t threshold=0.0] [-z zerobits=0] [-n chainlength=10] file1 file2 file3 ...
#
# Options -t, -z, -n replicate Sherlock's arguments with threshold (-t) rescaled to the interval [0,1],
# and with different default values: threshold=0.0, zerobits=0, chainlength=10.
#
# Examples:
#
#   ./scarlet.rb path/*.py
#
#   ./scarlet.rb -t0.7 path/*.py
#
#   ./scarlet.rb -t0.5 -z1 -n7 *.cpp
# 

require 'tmpdir'
require 'rouge'
require 'optparse'

def lex(filename, output_filename)
  source = File.read(filename)
  lexer = Rouge::Lexer.guess_by_filename(filename).new

  out_file = File.open(output_filename, 'w+')
  lexer.lex(source).each{|tok, chunk|
    if tok.shortname != '' && tok.shortname[0] != 'c' && tok.shortname[0] != 'p' # ignore comments
      #puts "#{tok.shortname} #{chunk.inspect}"
      short = tok.shortname
      if (short[0] == 'k' || short[0] == 'o') 
        out_file.print "#{short}_#{chunk}"
      else
        out_file.print short
      end
      out_file.print ' '
    end
  }
  out_file.close
end

# Read CLI options (for Sherlock)
options = {:t => 0.0, :z => 0, :n => 10}
OptionParser.new do |opts|
  opts.on('-t NUM', Float)
  opts.on('-z NUM', Integer)
  opts.on('-n NUM', Integer)
end.parse!(into: options)

# Use Rouge Lexer
files = ARGV
if files.size == 0
  exit(1)
end
dirs = files.map{|f| File.dirname(f)}
all_in_same_dir = dirs.all?{|d| d==dirs[0]}

Dir.mktmpdir {|tempdir|
  ARGV.each{|file|
    out_basename = 'x'
    if all_in_same_dir
      out_basename = File.basename(file).gsub(/\s/, '-') # replace whitespace with '-'
    else
      out_basename = file.gsub(/\/|\.|\s/,'-') # replace '/', '.', and whitespace with '-'
    end
    lex(file, "#{tempdir}/#{out_basename}")
  }

  # Run sherlock
  sherlock = './better-sherlock/sherlock'

  system("#{sherlock} -t #{options[:t]} -n #{options[:n]} -z #{options[:z]} #{tempdir}/*")
}
