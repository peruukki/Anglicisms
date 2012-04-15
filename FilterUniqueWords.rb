require 'io/console'

CurrentDir = File.dirname(__FILE__) + '/'
require File.expand_path(CurrentDir + 'WordClassifierDirectTranslatedOriginal')
require File.expand_path(CurrentDir + 'Helpers')

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
