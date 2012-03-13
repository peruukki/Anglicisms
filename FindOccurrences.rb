require 'io/console'

CurrentDir = File.dirname(__FILE__) + '/'
require File.expand_path(CurrentDir + 'WordClassifier')
require File.expand_path(CurrentDir + 'Helpers')

include Helpers

#
# Methods
#

def get_cmd_line_args()
  # Command line argument count check
  raise "Arguments: <word> <surrounding word count> <directory1> [<directory2> ...]" if ARGV.length < 3

  # The command line passes arguments ANSI encoded, convert them to UTF-8
  search_word = to_utf8(ARGV[0])
  surround_count = ARGV[1].to_i
  dirs = get_dirs_from_cmd_line_args(ARGV[2..-1])

  # Command line argument validation
  raise "Surrounding word count must be larger than zero" if surround_count <= 0
  
  [search_word, surround_count, dirs]
end


#
# Main
#

search_word, surround_count, dirs = get_cmd_line_args

# Start
puts "Finding occurrences of word '#{search_word}' with #{surround_count.to_s} surrounding words."
puts "Press any key to continue at each pause, 'q' to quit..."
pause

dirs.each do |directory|
  occurrence_count = 0
  Dir[directory + "/*.txt"].each do |file_name|
    recent_words = Array.new((2 * surround_count) + 1)
    word_index = surround_count
    
    puts "Analyzing file " + file_name
    position = read_file(file_name).gsub(/\n/, " ")
    word = ""
    trailing_word_count = surround_count
    
    until trailing_word_count == 0 do
      word, punctuation, position = get_next_word(position)
      recent_words.shift    
      if word.nil?
        # Add enough trailing words to take the very last words into account too
        trailing_word_count -=1
        recent_words.push nil
      else
        recent_words.push [word, punctuation]
      end
      
      if ((not recent_words[word_index].nil?) and
          (same_word?(recent_words[word_index][0], search_word)))
        occurrence_count += 1
        print "   ... "
        recent_words.each { |recent_word| print recent_word[0] + recent_word[1] unless recent_word.nil? }
        print "...\n"
        pause
      end
    end
  end
  puts "#{occurrence_count.to_s} occurrences of word '#{search_word}' " +
       "found in directory #{directory}."
end
