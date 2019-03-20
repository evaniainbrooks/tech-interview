# frozen_string_literal: true

require_relative 'yatzy'
require 'test/unit'

class YatzyTest < Test::Unit::TestCase
  def test_ones
    assert_equal 0,  Yatzy.ones(6, 2, 2, 4, 5)
    assert_equal 1,  Yatzy.ones(1, 2, 3, 4, 5)
    assert_equal 2,  Yatzy.ones(1, 2, 1, 4, 5)
    assert_equal 4,  Yatzy.ones(1, 2, 1, 1, 1)
  end

  def test_twos
    assert_equal 4,  Yatzy.twos(1, 2, 3, 2, 6)
    assert_equal 10, Yatzy.twos(2, 2, 2, 2, 2)
  end

  def test_threes
    assert_equal 6,  Yatzy.threes(1, 2, 3, 2, 3)
    assert_equal 12, Yatzy.threes(2, 3, 3, 3, 3)
  end

  def test_fours
    assert_equal 4,  Yatzy.new(4, 5, 5, 5, 5).fours
    assert_equal 8,  Yatzy.new(4, 4, 5, 5, 5).fours
    assert_equal 12, Yatzy.new(4, 4, 4, 5, 5).fours
  end

  def test_fives
    assert_equal 10, Yatzy.new(4, 4, 4, 5, 5).fives
    assert_equal 15, Yatzy.new(4, 4, 5, 5, 5).fives
    assert_equal 20, Yatzy.new(4, 5, 5, 5, 5).fives
  end

  def test_sixes
    assert_equal 0,  Yatzy.new(4, 4, 4, 5, 5).sixes
    assert_equal 6,  Yatzy.new(4, 4, 6, 5, 5).sixes
    assert_equal 18, Yatzy.new(6, 5, 6, 6, 5).sixes
  end

  def test_one_pair
    assert_equal 0,  Yatzy.score_pair(1, 2, 3, 4, 5)
    assert_equal 6,  Yatzy.score_pair(3, 4, 3, 5, 6)
    assert_equal 10, Yatzy.score_pair(5, 3, 3, 3, 5)
    assert_equal 12, Yatzy.score_pair(5, 3, 6, 6, 6)
  end

  def test_score_for_roll
    assert_equal 2,  Yatzy.score_roll([1, 1, 2, 2, 3], 1)
  end
end
