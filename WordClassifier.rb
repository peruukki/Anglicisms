require File.expand_path(File.dirname(__FILE__) + '/Helpers')

class WordClassifier
  include Helpers
  
  CurrentDir = File.dirname(__FILE__) + '/'
  FileNameBody = 'words.'

  Back = 'b'
  
  def initialize(ignore_class = nil)
    @word_classes = []
    @ignore_class = ignore_class
    @file_names = Hash.new
    @classified = Hash.new
  end

  def add_class(word_class)
    @word_classes.push word_class
    @file_names[word_class] = FileNameBody + word_class
    @classified[word_class] = get_words(@file_names[word_class])
  end

  def get_words(file_name)
    read_words_from_file(file_name)
  end
  private :get_words

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

end
