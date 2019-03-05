# frozen_string_literal: true

require_relative './trie'

class T9Predict
  ALPHABET = ('a'..'z').to_a.freeze

  BTN_SMART_PUNCT = 1
  BTN_SPACE = 0

  def self.map_button_characters(digit)
    return [' '] if [BTN_SMART_PUNCT, BTN_SPACE].include?(digit)

    start_index = (digit - 2) * 3
    char_count = digit == 9 ? 4 : 3
    end_index = start_index + char_count
    ALPHABET[start_index...end_index]
  end

  def initialize(dictionary)
    @trie = Trie.new(dictionary)
    reset
  end

  def input_sequence(digits)
    digits.inject(nil) { |_, digit| input(digit) }
  end

  def input(digit)
    extend_sequence(digit)

    result = []
    @prefixes.each.with_index do |prefix, i|
      prefix_suggestions = @trie.find_suggestions(prefix)
      @prefixes[i] = nil unless prefix_suggestions.length > 0
      result.concat(prefix_suggestions)
    end

    result.flatten.compact
  end

  def reset
    @sequence = []
    @prefixes = []
  end

  private

  def extend_sequence(digit)
    @sequence << digit
    chars = self.class.map_button_characters(digit)

    if @prefixes.length == 0
      @prefixes = chars.to_a
    else
      result = []
      chars.each do |char|
        @prefixes.compact.each do |prefix|
          result << (prefix + char)
        end
      end

      @prefixes = result
    end
  end
end
