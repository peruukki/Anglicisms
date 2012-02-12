require File.expand_path(CurrentDir + 'WordClassifier')

class WordClassifierYesNoMaybe < WordClassifier

  # Class name; input character; choice description
  Yes = [ 'yes', 'y' ]
  No = [ 'no', 'n' ]
  Maybe = [ 'maybe', 'm' ]
  WordClasses = [ Yes, No, Maybe ]

  def initialize()
    super(No)
    WordClasses.each { |word_class| add_class(word_class[0]) }
  end

  def classify_word(word, input)
    WordClasses.each do |word_class, class_input, class_desc|
      if (input == class_input)
        classify(word, word_class)
        return true
      end
    end
    false
  end

end
