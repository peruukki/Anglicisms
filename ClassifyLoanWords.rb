# This script iterates the words in the text files in the given directories
# and asks the user if the words have been loaned from English.

# Only words that have been classified as (possibly) interesting are taken
# into account. The files containing interesting words are read from the
# current directory.

require 'io/console'

LibDir = File.dirname(__FILE__) + '/lib/'
require File.expand_path(LibDir + 'WordClassifierDirectTranslatedOriginal')
require File.expand_path(LibDir + 'WordClassifierYesNoMaybe')
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
classifier = WordClassifierDirectTranslatedOriginal.new
quit = false

puts "Analyzing words in directory " + directory
WordClassifierYesNoMaybe::get_interesting_word_files(directory).each do |file_name|
  quit = classifier.classify_words_in_file(file_name)
  break if quit
end
classifier.save
