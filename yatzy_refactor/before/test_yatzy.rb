require_relative 'yatzy'
require 'test/unit'

class YatzyTest < Test::Unit::TestCase
  def test_1s
    assert Yatzy.ones(1,2,3,4,5) == 1
    assert 2 == Yatzy.ones(1,2,1,4,5)
    assert 0 == Yatzy.ones(6,2,2,4,5)
    assert 4 == Yatzy.ones(1,2,1,1,1)
  end

  def test_2s
    assert Yatzy.twos(1,2,3,2,6) == 4
    assert Yatzy.twos(2,2,2,2,2) == 10
  end

  def test_threes
    assert 6 == Yatzy.threes(1,2,3,2,3)
    assert 12 == Yatzy.threes(2,3,3,3,3)
  end

  def test_fours_test
    assert 12 == Yatzy.new(4,4,4,5,5).fours
    assert 8 == Yatzy.new(4,4,5,5,5).fours
    assert 4 == Yatzy.new(4,5,5,5,5).fours
  end

  def test_fives()
    assert 10 == Yatzy.new(4,4,4,5,5).fives()
    assert 15 == Yatzy.new(4,4,5,5,5).fives()
    assert 20 == Yatzy.new(4,5,5,5,5).fives()
  end

  def test_sixes_test
    assert 0 == Yatzy.new(4,4,4,5,5).sixes()
    assert 6 == Yatzy.new(4,4,6,5,5).sixes()
    assert 18 == Yatzy.new(6,5,6,6,5).sixes()
  end

  def test_one_pair
    assert 6 == Yatzy.score_pair(3,4,3,5,6)
    assert 10 == Yatzy.score_pair(5,3,3,3,5)
    assert 12 == Yatzy.score_pair(5,3,6,6,6)
    assert 0 == Yatzy.score_pair(1,2,3,4,5)
  end

  def test_score_for_roll
    roll = [1,1,2,2,3]
    assert 2 == Yatzy.score_roll(roll, 1)
  end
end
