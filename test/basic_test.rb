require_relative 'test_helper'

# For faster tests RubyRhymes is initialized outside of the test loop.
RubyRhymes.init

describe 'BasicTest' do
  describe 'smoke test' do
    it 'must be defined - VERSION' do
      RubyRhymes::VERSION.wont_be_nil
    end
  end

  describe 'handle dict words' do
    let (:phrase) { RubyRhymes.phrase('to be or not to beer') }

    it 'returns false for non-dict words' do
      phrase.dict?.must_equal true
    end

    it 'should count syllables' do
      phrase.syllables.must_equal 6
    end

    it 'should generate rhymes' do
      phrase.flat_rhymes.take(3).must_equal %w(adhere alvear amir)
    end

    it 'retruns the rhyme_keys' do
      phrase.rhyme_keys.must_equal ['/U']
    end
  end


  describe 'handle non-dict words' do
    let (:phrase) { RubyRhymes.phrase('twerk') }

    it 'returns false for non-dict words' do
      phrase.dict?.must_equal false
    end

    it 'should rerun empty array for non-dict words' do
      phrase.flat_rhymes.must_equal []
    end
  end

  describe 'determine if 2 phrases rhyme' do
    it 'should return false for phrases that dont rhyme' do
      RubyRhymes.rhyme?('...is rough.', '...a cough!').must_equal :no_match
    end

    it 'should return true for phrases that rhyme' do
      RubyRhymes.rhyme?('...is rough.', '...is tough.').must_equal :match
    end

    it 'should retrun something if multiples' do
      RubyRhymes.rhyme?('...my aunt.', '...an ant.').must_equal :possible_match
    end
  end
end
