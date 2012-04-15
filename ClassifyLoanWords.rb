require 'io/console'

CurrentDir = File.dirname(__FILE__) + '/'
require File.expand_path(CurrentDir + 'WordClassifierDirectTranslatedOriginal')
require File.expand_path(CurrentDir + 'WordClassifierYesNoMaybe')
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
classifier = WordClassifierDirectTranslatedOriginal.new
quit = false

puts "Analyzing words in directory " + directory
WordClassifierYesNoMaybe::get_interesting_word_files(directory).each do |file_name|
  quit = classifier.classify_words_in_file(file_name)
  break if quit
end
classifier.save
