require File.expand_path(CurrentDir + 'WordClassifier')
require File.expand_path(CurrentDir + 'WordClass')

class WordClassifierYesNoMaybe < WordClassifier

  Yes = WordClass.new('yes', 'y', '(y)es')
  No = WordClass.new('no', 'n', '(n)o', true)
  Maybe = WordClass.new('maybe', 'm', '(m)aybe')

  def initialize()
    super([Yes, No, Maybe])
  end

  def self.get_interesting_word_files(directory = '.')
    [directory + '/' + FileNameBody + Yes.class_name,
     directory + '/' + FileNameBody + Maybe.class_name]
  end

end
