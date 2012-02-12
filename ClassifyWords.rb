require 'io/console'

CurrentDir = File.dirname(__FILE__) + '/'
require File.expand_path(CurrentDir + 'WordClassifierYesNoMaybe')
require File.expand_path(CurrentDir + 'Helpers')

include Helpers

def get_cmd_line_args()
  raise "Arguments: <directory1> [<directory2> ...]" if ARGV.length < 1
  get_dirs_from_cmd_line_args(ARGV)
end

# Main

dirs = get_cmd_line_args
classifier = WordClassifierYesNoMaybe.new
quit = false

dirs.each do |directory|
  puts "Analyzing files in directory " + directory
  Dir["#{directory}/*.txt"].each do |file_name|
    puts "Classifying words in article " + file_name
    words = read_words_from_file(file_name)

    index = 0
    previous_indexes = []
    while index < words.length do
      word = words[index]
      unless classifier.classified?(word)
        known_choice = false
        print "Classify word '#{word}': (y)es / (n)o / (m)aybe / (b)ack: "
        choice = STDIN.getch
        puts choice
        
        known_choice = classifier.classify_word(word, choice)
        unless known_choice
          if (choice == WordClassifierYesNoMaybe::Back)
            if previous_indexes.empty?
              puts "No previous word"
            else
              index = previous_indexes.pop
              previous_word = words[index]
              puts "Going back to previous word '#{previous_word}'"
              classifier.unclassify(previous_word)
            end
            next
          else
            puts "Saving and exiting"
            quit = true
          end
        end
        previous_indexes.push index
        classifier.save if previous_indexes.length % 5 == 0
      end
      index += 1
      break if quit
    end
    break if quit
  end
  break if quit
end
classifier.save
