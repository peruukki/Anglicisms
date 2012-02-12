﻿CurrentDir = File.dirname(__FILE__) + '/'
require File.expand_path(CurrentDir + 'WordClassifier')
require File.expand_path(CurrentDir + 'Helpers')

include Helpers

def get_cmd_line_args()
  # Command line argument count check
  raise "Arguments: <directory1> [<directory2> ...]" if ARGV.length < 1

  # The command line passes arguments ANSI encoded, convert them to UTF-8
  dirs = []
  (0..ARGV.length - 1).each { |i| dirs.push to_utf8(ARGV[i]) }
  dirs
end

def sort_frequencies(freqs)
  freqs.sort_by { |word, count| -count }
end

def count_frequencies(file_name, classifier)
  freqs = Hash.new(0)
  read_words_from_file(file_name).each { |word| freqs[word] += 1 unless classifier.ignore?(word) }
  sort_frequencies(freqs)
end

# Main

dirs = get_cmd_line_args
classifier = WordClassifier.new

dirs.each do |directory|
  puts "Analyzing files in directory " + directory
  total_freqs = Hash.new(0)
  article_counts = Hash.new(0)
  Dir["#{directory}/*.txt"].each do |file_name|
    puts "Analyzing file " + file_name
    freqs = count_frequencies(file_name, classifier)
    freqs.each do |word, count|
      total_freqs[word] += count
      article_counts[word] += 1
    end
    write_to_file("#{file_name}.freq", freqs)
  end

  puts "Sorting total frequencies"
  sorted_words = sort_frequencies(total_freqs)
  puts "Combining same words"
  time = Time.now
  same_words = combine_same_words(sorted_words, total_freqs, article_counts)
  puts "Combining took #{Time.now - time} seconds"
  puts "Analyzing total counts"
  write_to_file("#{directory}/all.freq", sort_frequencies(total_freqs), article_counts, same_words)
end
