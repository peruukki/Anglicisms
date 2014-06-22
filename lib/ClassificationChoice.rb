# This class represents a classification choice available for the user in
# scripts that classify words.

class ClassificationChoice
  attr_reader :input_char, :description

  def initialize(input_char, description)
    @input_char = input_char
    @description = description
  end

end
