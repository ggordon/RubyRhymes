# RubyRhymes is meant to facilitate the creation of automated poetry
# Authors::    Vlad Shulman (vshulman@github) and Thomas Kielbus (thomas-kielbus@github)
# License::   Distributes under the same terms as Ruby

# Pronunciations does the heavy lifting, interfacing with the mythical text file of doom
require 'singleton'
module RubyRhymes
  class Pronunciations
    include Singleton

    def initialize
      @pronunciations = {}
      @multiple_pronunciations = {}
      @rhymes = {}
    end

    def get_pronunciations(word)
      pronunciations = @multiple_pronunciations[word]
      if pronunciations != nil # Multiple pronunciations case
        return pronunciations
      else # Single or pronunciation case
        pronunciation = get_pronunciation(word)
        if pronunciation
          return [pronunciation]
        else
          return [Pronunciation.new(word, nil, auto_syllables(word.downcase), nil)]
        end
      end
    end

    # Returns arrays of rhymes -- an Array of rhymes for each pronunciation
    def get_rhymes(pronunciation)
      rhymes = @rhymes[pronunciation.rhyme_key]
      rhymes.delete(pronunciation)
      rhymes
    end

    def load(words_path, rhymes_path, multiple_pronunciations_path)
      process_file(words_path, :process_words)
      process_file(multiple_pronunciations_path, :process_multiple_pronunciations)
      process_file(rhymes_path, :process_rhymes)
    end

    private

    def get_pronunciation(pronunciation_id)
      @pronunciations[pronunciation_id]
    end

    def get_word_from_pronunciation_id(pronunciation_id)
      return pronunciation_id.split('(')[0]
    end

    # based entirely off of http://www.russellmcveigh.info/content/html/syllablecounter.php
    def auto_syllables(word)
      valid_word_parts = []
      word_parts = word.split(/[^aeiouy]+/).each do |value|
        if !value.empty?
          valid_word_parts << value
        end
      end

      syllables = 0;
      # Thanks to Joe Kovar for correcting a bug in the following lines
      sybsyl.each { |syl| syllables -= (syl.match(word).nil? ? 0 : 1) }

      addsyl.each { |syl| syllables += (syl.match(word).nil? ? 0 : 1) }

      # UBER EXCEPTIONS - WORDS THAT SLIP THROUGH THE NET
      syllables -= 1 if exceptions_one.include?(word)

      syllables += valid_word_parts.count
      syllables = (syllables == 0) ? 1 : syllables
    end

    def addsyl
      SyllableArrays::ADDSYL
    end
    def sybsyl
      SyllableArrays::SYBSYL
    end
    def exceptions_one
      SyllableArrays::EXCEPTIONS_ONE
    end



    def process_file(file_path, meth)
      File.open(File.expand_path(file_path, __FILE__), 'r') do |lines|
        while (line = lines.gets)
          send(meth, line)
        end
      end
    end

    def process_multiple_pronunciations(line)
      pronunciations = line.split(' ')
      word = pronunciations.slice!(0)
      pronunciations.map! do |p|
        @pronunciations[p]
      end
      pronunciations.reject!(&:nil?)
      @multiple_pronunciations[word] = pronunciations
    end

    def process_words(line)
      parts = line.split(' ')
      pronunciation_id = parts[0]
      word = get_word_from_pronunciation_id(pronunciation_id)
      num_syllables = parts[2].to_i
      rhyme_key = parts[1]
      @pronunciations[pronunciation_id] = Pronunciation.new(word, pronunciation_id, num_syllables, rhyme_key)
    end

    def process_rhymes(line)
      parts = line.split(' ')
      rhyme_key = parts.slice(0)
      rhyme_pronunciations = parts.slice(1..-1)
      rhyme_pronunciations.map! { |p| @pronunciations[p] }
      @rhymes[rhyme_key] = rhyme_pronunciations
    end

  end
end
