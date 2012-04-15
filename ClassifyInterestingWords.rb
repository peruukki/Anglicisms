require 'io/console'

CurrentDir = File.dirname(__FILE__) + '/'
require File.expand_path(CurrentDir + 'WordClassifierYesNoMaybe')
require File.expand_path(CurrentDir + 'Helpers')

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
