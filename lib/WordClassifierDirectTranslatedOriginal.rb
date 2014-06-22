# This class classifies words to classes that describe what kind of loan word
# the word is.

require File.expand_path(LibDir + 'WordClassifier')
require File.expand_path(LibDir + 'WordClass')

class WordClassifierDirectTranslatedOriginal < WordClassifier

  Direct = WordClass.new('direct', 'd', '(d)irect')
  Translated = WordClass.new('translated', 't', '(t)ranslated')
  Original = WordClass.new('original', 'o', '(o)riginal', true)

  def initialize()
    super([Direct, Translated, Original])
  end

  def self.get_interesting_word_files(directory = '.')
    [directory + '/' + FileNameBody + Direct.class_name,
     directory + '/' + FileNameBody + Translated.class_name]
  end

end
