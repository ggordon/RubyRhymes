# RubyRhymes is meant to facilitate the creation of automated poetry
# Authors::    Vlad Shulman (vshulman@github) and Thomas Kielbus (thomas-kielbus@github)
# License::   Distributes under the same terms as Ruby

# this class is the gateway to generating exciting poetry. Use it like this:
#
# >> phrase = "to be or not to beer".to_phrase
# >> phrase.flat_rhymes
# => ["adhere", "alvear", "amir", ...]
# >> "to be or not to beer".to_phrase.syllables
# => 6

require 'ruby_rhymes/version'
require 'ruby_rhymes/pronunciation'
require 'ruby_rhymes/syllable_arrays'
require 'ruby_rhymes/pronunciations'
require 'ruby_rhymes/phrase'

module RubyRhymes

  WORDS_PATH = '../../../resources/words.txt'
  RHYMES_PATH = '../../../resources/rhymes.txt'
  MULTIPLES_PATH = '../../../resources/multiple.txt'

  def self.init(words_path = WORDS_PATH, rhymes_path = RHYMES_PATH, multiple_pronunciations_path = MULTIPLES_PATH)
    RubyRhymes::Pronunciations.instance.load(words_path, rhymes_path, multiple_pronunciations_path)
  end

  def self.phrase(str)
    RubyRhymes::Phrase.new(str)
  end

  def self.rhyme?(phrase1, phrase2)
    keys1 = phrase(phrase1).rhyme_keys
    keys2 = phrase(phrase2).rhyme_keys
    if keys1.empty? || keys2.empty?
      :not_in_dict
    elsif keys1.size == 1 && keys2.size == 1
      if keys1 == keys2
        :match
      else
        :no_match
      end
    else
      if (keys1 & keys2).size > 0
        :possible_match
      else
        :no_match
      end
    end
  end
end

