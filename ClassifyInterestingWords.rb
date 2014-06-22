# This script iterates the words in the text files in given directories and
# asks the user if the words are interesting for further analysis.

require 'io/console'

LibDir = File.dirname(__FILE__) + '/lib/'
require File.expand_path(LibDir + 'WordClassifierYesNoMaybe')
require File.expand_path(LibDir + 'Helpers')

include Helpers

def get_cmd_line_args()
  if ARGV.length < 1
    puts "\nArguments: <directory1> [<directory2> ...]"
    exit
  end
  get_dirs_from_cmd_line_args(ARGV)
end

# Main

dirs = get_cmd_line_args
classifier = WordClassifierYesNoMaybe.new
quit = false

dirs.each do |directory|
  puts "Analyzing files in directory " + directory
  Dir["#{directory}/*.txt"].each do |file_name|
    quit = classifier.classify_words_in_file(file_name)
    break if quit
  end
  break if quit
end
classifier.save
