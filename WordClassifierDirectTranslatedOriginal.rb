require File.expand_path(CurrentDir + 'WordClassifier')
require File.expand_path(CurrentDir + 'WordClass')

class WordClassifierDirectTranslatedOriginal < WordClassifier

  Direct = WordClass.new('direct', 'd', '(d)irect')
  Translated = WordClass.new('translated', 't', '(t)ranslated')
  Original = WordClass.new('original', 'o', '(o)riginal', true)

  def initialize()
    super([Direct, Translated, Original])
  end

end
