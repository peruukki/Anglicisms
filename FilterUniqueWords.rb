# This script reads the (possibly) interesting words from the given directory
# and filters out the different forms of a word so that only unique words remain.

require 'io/console'

LibDir = File.dirname(__FILE__) + '/lib/'
require File.expand_path(LibDir + 'WordClassifierDirectTranslatedOriginal')
require File.expand_path(LibDir + 'Helpers')

include Helpers

def get_cmd_line_args()
  if ARGV.length != 1
    puts "\nArguments: <directory>"
    exit
  end
  get_dirs_from_cmd_line_args(ARGV).first
end


# Main

directory = get_cmd_line_args
puts "Filtering unique words in directory " + directory

WordClassifierDirectTranslatedOriginal::get_interesting_word_files(directory).each do |file_name|
  filtered_file = file_name + '.filtered'

  puts "Analyzing file " + file_name
  filtered_words = combine_same_words(read_words_from_file(file_name))
  puts "Writing filtered words to file " + filtered_file
  write_words_to_file(filtered_words, filtered_file)
end
