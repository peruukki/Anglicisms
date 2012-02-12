require File.expand_path(CurrentDir + 'WordClassifier')
require File.expand_path(CurrentDir + 'WordClass')

class WordClassifierYesNoMaybe < WordClassifier

  Yes = WordClass.new('yes', 'y', '(y)es')
  No = WordClass.new('no', 'n', '(n)o', true)
  Maybe = WordClass.new('maybe', 'm', '(m)aybe')
  WordClasses = [ Yes, No, Maybe ]

  def initialize()
    super(WordClasses)
  end

end
