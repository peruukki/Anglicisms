CurrentDir = File.dirname(__FILE__) + '/'
require File.expand_path(CurrentDir + 'Helpers')

include Helpers

def get_cmd_line_args()
  raise "Arguments: <directory1> [<directory2> ...]" if ARGV.length < 1
  get_dirs_from_cmd_line_args(ARGV)
end

# Main

dirs = get_cmd_line_args
summary_word_counts = []

dirs.each do |directory|
  puts "Counting words in directory " + directory

  total_word_count = 0
  Dir["#{directory}/*.txt"].each do |file_name|
    position = read_file(file_name)
    word = ""
    file_word_count = 0
    while not word.nil?
      word, punctuation, position = get_next_word(position)
      file_word_count += 1 unless word.nil?
    end
    puts "#{file_word_count} words in file #{file_name}"
    total_word_count += file_word_count
  end
  
  puts "#{total_word_count} words in directory #{directory}"
  summary_word_counts.push [total_word_count, directory]
end

if (summary_word_counts.length > 1)
  puts "\nSummary of word counts:"
  summary_word_counts.each do |word_count, directory|
    puts "#{word_count} words in directory #{directory}"
  end
end
