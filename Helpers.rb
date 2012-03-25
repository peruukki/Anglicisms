module Helpers

  Punctuation = '«»\'’:;,!…\?\*\(\)\[\]\.\s'
  SplitPattern = /[#{Punctuation}]+/
  WordPattern = /([^#{Punctuation}]+)([#{Punctuation}]+)?/
  WordsWithApostrophe = ["d'abord", "d'affilée", "d'ailleurs", "d'autres",
                         "d'habitude", "d'ici", "d'où", "l'un"]

  def pause()
    exit if STDIN.getch == 'q'
  end
  
  def to_utf8(ansi_string)
    String.new(ansi_string).force_encoding('windows-1252').encode('utf-8')
  end

  def get_dirs_from_cmd_line_args(arg_dirs)
    # The command line passes arguments ANSI encoded, convert them to UTF-8
    dirs = []
    arg_dirs.each { |dir_path| dirs.push to_utf8(dir_path).gsub('\\', '/') }
    dirs
  end

  def word_with_apostrophe?(word)
    if WordsWithApostrophe.include?(word)
      puts "Word with apostrophe: " + word
      return true
    end
    false
  end

  def get_next_word(text, prev_word = nil, prev_punctuation = nil)
    if ((not text.nil?) and (text =~ WordPattern))
      word = $1
      punctuation = ($2.nil? ? "" : $2)
      position = $'
      if ((prev_punctuation == "'") and
          (word_with_apostrophe?(prev_word + "'" + word)))
        return get_next_word(position, word, punctuation)
      end
      return [word, punctuation, position]
    end
    return [nil, nil, nil]
  end

  def match?(w1, w2)
    return true if (w1 == w2 + 's')
    return true if (w1 == w2 + 'e')
    return true if ((w1 =~ /^(.+)eux$/) and (w2 =~ /^#{$1}euse$/))
    return true if ((w1 =~ /^(.+)if$/) and (w2 =~ /^#{$1}ive$/))
    return true if ((w1 =~ /^(.+)al(e|es)?$/) and (w2 =~ /^#{$1}aux$/))
    if (w1 =~ /^(.+)er$/)
      body = $1
      return true if (w2 =~ /^#{body}ée?s?$/)
      return true if (w2 =~ /^#{body}(ai)?(a|e)nt$/)
      return true if (w2 =~ /^#{body}(e|ait)$/)
    end
    return false
  end

  def same_word?(word1, word2)
    w1 = word1.downcase
    w2 = word2.downcase
    return true if (w1 == w2)
    return true if match?(w1, w2)
    return true if match?(w2, w1)
    false
  end

  def combine_same_words(sorted_words, freqs, article_counts)
    same_words = Hash.new
    sorted_words.each.with_index do |entry1, i|
      word1, count1 = entry1
      next if freqs[word1] == 0
      for j in (i + 1)..(sorted_words.length - 1)
        word2, count2 = sorted_words[j]
        next if freqs[word2] == 0
        if same_word?(word1, word2)
          if same_words[word1].nil?
            same_words[word1] = ""
          else
            same_words[word1] += ", "
          end
          same_words[word1] += word2 + " " + freqs[word2].to_s +
                               " (" + article_counts[word2].to_s + ")"
          freqs[word1] += freqs[word2]
          freqs.delete(word2)
        end
      end
    end
    same_words
  end
  
  def read_file(file_name, directory = './')
    file_name = File.expand_path(directory + file_name)
    return "" unless File.exist?(file_name)
    File.open(file_name, "r:UTF-8") { |f| f.read }
  end

  def read_words_from_file(file_name, directory = './')
    read_file(file_name, directory).split(SplitPattern)
  end

  def write_words_to_file(words, file_name, directory = './')
    file_name = File.expand_path(directory + file_name)

    # Create a backup just in case
    File.rename(file_name, file_name + ".bak") if File.exist?(file_name)
    
    file = File.new(file_name, "w:UTF-8")
    words.sort.each { |word| file.puts word }
    file.close
  end
  
  def write_to_file(file_name, freqs, article_counts = nil, same_words = nil)
    file = File.new(file_name, "w:UTF-8")
    freqs.each do |word, count|
      file.puts "%3s " % count.to_s +
              (article_counts.nil? ? "" : "(%2d) " % article_counts[word]) +
          word +
          ((same_words.nil? or same_words[word].nil?) ? "" : " (%s)" % same_words[word])
    end
    file.close
  end
  
end
