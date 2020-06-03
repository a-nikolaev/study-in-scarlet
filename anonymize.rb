#! /bin/env ruby

# Anonymizes filenames in the table by replacing them with unique 3-letter 
# strings (the number of letters will increase to 4, 5, etc. if need be).
# The generated sequences are computed from hashed filenames themselves, so these
# nicknames are stable and will not change between executions of the program,
# as long as the filenames in the table stay the same.
#
# Usage:
#   
#   cat table | ./anonymize.rb 

require 'digest'

@N = 3   # number of letters

@hash = Hash.new
@rev_hash = Hash.new

def get_name(s)
  if @hash[s] == nil

    # give a new name
    code = (Digest::MD5.hexdigest(s).hex) % (26**@N)
    t = ''
    while t == '' || @rev_hash[t] != nil
      t = ''
      c = code
      puts code
      @N.times{
        t += ('A'.ord + (c % 26)).chr
        c /= 26
      }
      code = (code + 1) % (26**@N)
    end
    @hash[s] = t
    @rev_hash[t] = s
    if @hash.size > 0.5 * (26**@N)
      @N += 1 # add letters
    end

  end
    
  @hash[s]
end


STDIN.each_line{|line|
  arr = line.split
  if arr.size > 2 
    arr[0] = get_name(arr[0])
    arr[1] = get_name(arr[1])
    puts arr.join(' ')
  else
    puts line
  end
}
