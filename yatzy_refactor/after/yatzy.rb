# frozen_string_literal: true

require 'set'

class YatzyLogic
  def self.score(n, dice)
    dice.count(n) * n
  end

  def self.score_pair(dice)
    visited = Set.new
    dice.inject(0) do |highest_pair, dice|
      highest_pair = dice if visited.include?(dice) && dice > highest_pair
      visited.add(dice)
      highest_pair
    end * 2
  end
end

class Yatzy
  DICE_SYMBOLS = %i(ones twos threes fours fives sixes).freeze

  def initialize(*dice)
    @dice = dice
  end

  def self.score_pair(*dice)
    YatzyLogic.score_pair(dice)
  end

  def self.score_roll(dice, n)
    YatzyLogic.score(n, dice)
  end

  DICE_SYMBOLS.each.with_index do |sym, i|
    define_method(sym) do
      YatzyLogic.score(i + 1, @dice)
    end

    self.class.define_method(sym) do |*dice|
      YatzyLogic.score(i + 1, dice)
    end
  end
end
