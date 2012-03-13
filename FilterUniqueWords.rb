require 'io/console'

CurrentDir = File.dirname(__FILE__) + '/'
require File.expand_path(CurrentDir + 'WordClassifierDirectTranslatedOriginal')
require File.expand_path(CurrentDir + 'Helpers')

include Helpers

def get_cmd_line_args()
  raise "Arguments: <directory>" if ARGV.length != 1
  get_dirs_from_cmd_line_args(ARGV).first
end


# Main

directory = get_cmd_line_args
puts "Filtering unique words in directory " + directory

WordClassifierDirectTranslatedOriginal::get_interesting_word_files(directory).each do |file_name|
  filtered_file = file_name + '.filtered'
  filtered_words = []

  puts "Analyzing file " + file_name
  read_words_from_file(file_name).each do |word|
    known_word = false
    filtered_words.each do |filtered_word|
      if (same_word?(word, filtered_word))
        known_word = true
        break
      end
    end
    filtered_words.push word.downcase unless known_word
  end
  puts "Writing filtered words to file " + filtered_file
  write_words_to_file(filtered_words, filtered_file)
end
