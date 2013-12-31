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

module RubyRhymes
  class Phrase
    def initialize(phrase)
      @phrase_tokens = Phrase.clean_and_tokenize(phrase)

      # [[p1a,p1b],[p2],p3]
      @pronunciations = @phrase_tokens.map { |pt| Pronunciations.instance.get_pronunciations(pt) } #pronunciation objects
      @last_word_pronunciation = @pronunciations.last
    end

    # returns the rhyme keys associated with this word (useful in matching with other words to see if they rhyme)
    def rhyme_keys
      @last_word_pronunciation.map(&:rhyme_key).compact||[]
    end

    # returns the first rhyme key or nil
    def rhyme_key
      rhyme_keys.first
    end

    # returns the number of syllables in the phrase
    def syllables
      @pronunciations.map { |p| p.first.num_syllables }.inject(:+)
    end

    # returns whether the last word in the phrase a dictionary word (useful to know before calling rhymes and rhyme_keys)
    def dict?
      @last_word_pronunciation.first.dict?
    end

    # returns a map from rhyme key to a list of rhyming words in that key
    def rhymes
      @rhymes = load_rhymes if @rhymes.nil?
      @rhymes
    end

    # return a flat array of rhymes, rather than by pronunciation
    def flat_rhymes
      rhymes.empty? ? [] : @rhymes.values.flatten
    end

    # returns the last word in the phrase (the one used for rhyming)
    def last_word
      @last_word_pronunciation.first.word.downcase
    end

    private

    # lazy loading action
    def load_rhymes
      return {} if !@last_word_pronunciation.first.dict?

      rhymes = Hash.new([])
      @last_word_pronunciation.each do |pronunciation|
        rhymes[pronunciation.rhyme_key] = Pronunciations.instance.get_rhymes(pronunciation).map { |x| x.word.downcase }
      end
      rhymes
    end

    # we upcase because our dictionary files are upcased
    def self.clean_and_tokenize(phrase)
      phrase.upcase.gsub(/[^A-Z ']/, '').split
    end
  end
end

