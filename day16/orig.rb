# Advent of Code - Day x
require_relative "../helpers"

def read_file_to_binary(file_path)
  line = File.readlines(file_path).map(&:chomp).first
  line.hex.to_s(2).rjust(line.size*4, '0')
end
def read_literal(input)
  # puts "reading literal #{input}"
  bits = ""
  loop do
    indicator = input.slice!(0)
    # p indicator
    last = indicator == "0" ? true : false
    bits += input.slice!(0..3)
    # p bits
    break if last==true
  end
  [bits.to_i(2), input]
end

def read_bit(input, version_sum)
  # puts "Currently Attempting to parse #{input}"

  version = input.slice!(0..2).to_i(2)
  version_sum+=version
  type = input.slice!(0..2).to_i(2)

  # puts "Version #{version} and type #{type}"

  content = 0

  case type
  when 4
    # puts "Version 4 means read as literal"
    content, input= read_literal(input)
    # puts "Literal read #{content}"
  else
    # puts "Not version 4 means read as operator"
    length_type = input.slice!(0)
    # puts "Operator Length Type #{length_type}"
    case length_type
    when "0"
      length = input.slice!(0..14).to_i(2)
      # puts "case zero has 15 bit length: Length is #{length}"
      next_content, input, version_sum = read_bit(input, version_sum)
      content = produce_new_content(content, type, next_content)
      # content.concat(next_content.to_s)
      # puts "case zero Found #{next_content} and has new version sum of #{version_sum}"
    when "1"
      length = input.slice!(0..10).to_i(2)
      # puts "case one has 11 bit length: Length is #{length}"
      next_content = 0
      length.times do |iteration|
        single_content, input, version_sum = read_bit(input, version_sum)
        # puts "case one #{iteration} bit output read #{single_content} and a new version sum of #{version_sum}"
        next_content = produce_new_content(next_content, type, single_content)
        # next_content.concat(single_content.to_s)
        # puts "next_content is now #{next_content}"
      end
      # puts "case one is done with #{next_content}"
      content = produce_new_content(content, type, next_content)
      # content.concat(next_content)
      else
        abort "Unknown Type That should never happen #{type}"
    end
  end
  [content, input, version_sum]
end

def process(input)
  version_sum = 0
  loop do 
    output, input, version_sum = read_bit(input, version_sum)
    # puts "Process Loop output is #{output} with remaining input #{input} and version sum #{version_sum}"
    # puts "Process Loop output is #{output} and version sum #{version_sum}"
    break unless input.to_i(2) > 0
  end
end

def produce_new_content(content, type, next_content)
  # puts "Attempt to produce new content with #{content} #{type} #{next_content}"
  case type
  when 0 # Sum
    puts "producing sum"
    content += next_content
    # puts "new content #{content}"
  when 1 # Product
    puts "producing product"
    content *= next_content
    # puts "new content is #{content}"
  when 2 # Minimum
    puts "minimum"
  when 3 # maximum
    puts "max"
  when 5 # Gretaer Than
    puts "gt"
  when 6 # Less than
    puts "lt"
  when 7 # Equal To
    puts "eq"
  else
    abort "Unknown produce_new_content Type #{type}"
  end
  content

end

puts "#{process(read_file_to_binary("input.txt"))}"
