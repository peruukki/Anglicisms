# This class represents a word class usable in scripts that classify words.

require File.expand_path(LibDir + 'ClassificationChoice')

class WordClass < ClassificationChoice
  attr_reader :class_name, :ignore

  def initialize(class_name, input_char, description, ignore = false)
    super(input_char, description)
    @class_name = class_name
    @ignore = ignore
  end

end
