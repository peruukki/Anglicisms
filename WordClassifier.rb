require 'io/console'
require File.expand_path(CurrentDir + 'Helpers')
require File.expand_path(CurrentDir + 'ClassificationChoice')

class WordClassifier
  include Helpers

  CurrentDir = File.dirname(__FILE__) + '/'
  FileNameBody = 'words.'

  Back = ClassificationChoice.new('b', '(b)ack')

  def initialize(word_classes)
    @file_names = Hash.new
    @classified = Hash.new

    word_classes.each do |word_class|
      @file_names[word_class] = FileNameBody + word_class.class_name
      @classified[word_class] = get_words(@file_names[word_class])
      @ignore_class = word_class if word_class.ignore
    end
    @word_classes = word_classes
    @classification_choices = word_classes + [Back]
  end

  def get_words(file_name)
    read_words_from_file(file_name)
  end
  private :get_words

  def classify_words_in_file(file_name)
    quit = false
    puts "Classifying words in file " + file_name
    words = read_words_from_file(file_name)

    index = 0
    previous_indexes = []
    while index < words.length do
      word = words[index]
      unless classified?(word)
        prompt_message(word)
        choice = STDIN.getch
        puts choice

        known_choice = classify_word(word, choice)
        unless known_choice
          if (choice == Back.input_char)
            if previous_indexes.empty?
              puts "No previous word"
            else
              index = previous_indexes.pop
              previous_word = words[index]
              puts "Going back to previous word '#{previous_word}'"
              unclassify(previous_word)
            end
            next
          else
            puts "Saving and exiting"
            quit = true
          end
        end
        previous_indexes.push index
        save if previous_indexes.length % 5 == 0
      end
      index += 1
      break if quit
    end
    quit
  end

  def classified?(word)
    @classified.each_value { |words| return true if words.include?(word) }
    @classified.each do |word_class, words|
      words.each do |classified|
        if same_word?(word, classified)
          classify(word, word_class)
          return true
        end
      end
    end
    return false
  end

  def classify(word, word_class)
    raise "Unknown word class '#{word_class}'" unless @word_classes.include?(word_class)
    @classified[word_class].push(word)
  end

  def classify_word(word, input)
    @word_classes.each do |word_class|
      if (input == word_class.input_char)
        classify(word, word_class)
        return true
      end
    end
    false
  end

  def unclassify(word)
    @classified[get_class(word)].delete(word)
  end

  def get_class(word)
    @classified.each { |word_class, words| return word_class if words.include?(word) }
    nil
  end

  def has_class?(word, word_class)
    raise "Unknown word class '#{word_class}'" unless @word_classes.include?(word_class)
    @classified[word_class].include?(word)
  end

  def ignore?(word)
    return false if @ignore_class.nil?
    has_class?(word, @ignore_class)
  end

  def save()
    @word_classes.each do |word_class|
      write_words_to_file(@classified[word_class], @file_names[word_class])
    end
  end

  def prompt_message(word)
    message = "Classify word '#{word}':"
    @word_classes.each { |word_class| message += " #{word_class.description} /" }
    message += " #{Back.description}: "
    print message
  end

end
