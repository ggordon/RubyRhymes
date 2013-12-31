# RubyRhymes is meant to facilitate the creation of automated poetry
# Authors::    Vlad Shulman (vshulman@github) and Thomas Kielbus (thomas-kielbus@github)
# License::   Distributes under the same terms as Ruby

# a container of word, pronunciation_id, num_syllables, and rhyme_key

module RubyRhymes
  class Pronunciation
    attr_reader :word, :pronunciation_id, :num_syllables, :rhyme_key

    def initialize(word, pronunciation_id, num_syllables, rhyme_key)
      @word = word
      @pronunciation_id = pronunciation_id
      @num_syllables = num_syllables
      @rhyme_key = rhyme_key
    end

    # dictionary word?
    def dict?
      !!@pronunciation_id
    end

    def to_s
      word
    end
  end
end
