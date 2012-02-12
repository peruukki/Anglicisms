require File.expand_path(File.dirname(__FILE__) + '/Helpers')

class WordClassifier
  include Helpers
  
  CurrentDir = File.dirname(__FILE__) + '/'
  
  Yes = "yes"
  No = "no"
  Maybe = "maybe"
  WordClasses = [ Yes, No, Maybe ]
  
  def initialize()
    @file_names = Hash.new
    WordClasses.each { |word_class| @file_names[word_class] = "words." + word_class }
  
    @classified = Hash.new
    WordClasses.each { |word_class| @classified[word_class] = get_words(@file_names[word_class]) }
  end

  def get_words(file_name)
    read_words_from_file(file_name, CurrentDir)
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
    raise "Unknown word class '#{word_class}'" unless WordClasses.include?(word_class)
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
    raise "Unknown word class '#{word_class}'" unless WordClasses.include?(word_class)
    @classified[word_class].include?(word)
  end
  
  def ignore?(word)
    has_class?(word, No)
  end

  def save()
    WordClasses.each do |word_class|
      write_words_to_file(@classified[word_class], @file_names[word_class])
    end
  end

end
