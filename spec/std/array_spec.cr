#!/usr/bin/env bin/crystal --run
require "spec"

describe "Array" do
  describe "[]" do
    it "gets on positive index" do
      [1, 2, 3][1].should eq(2)
    end

    it "gets on negative index" do
      [1, 2, 3][-1].should eq(3)
    end

    it "gets on inclusive range" do
      [1, 2, 3, 4, 5, 6][1 .. 4].should eq([2, 3, 4, 5])
    end

    it "gets on inclusive range with negative indices" do
      [1, 2, 3, 4, 5, 6][-5 .. -2].should eq([2, 3, 4, 5])
    end

    it "gets on exclusive range" do
      [1, 2, 3, 4, 5, 6][1 ... 4].should eq([2, 3, 4])
    end

    it "gets on exclusive range with negative indices" do
      [1, 2, 3, 4, 5, 6][-5 ... -2].should eq([2, 3, 4])
    end

    it "gets on empty range" do
      [1, 2, 3][3 .. 1].should eq([] of Int32)
    end

    it "gets with start and count" do
      [1, 2, 3, 4, 5, 6][1, 3].should eq([2, 3, 4])
    end

    it "gets nilable" do
      [1, 2, 3][2]?.should eq(3)
      [1, 2, 3][3]?.should be_nil
    end

    it "same access by at" do
      [1, 2, 3][1].should eq([1,2,3].at(1))
    end

    it "doesn't exceed limits" do
      [1][0..3].should eq([1])
    end
  end

  describe "[]=" do
    it "sets on positive index" do
      a = [1, 2, 3]
      a[1] = 4
      a[1].should eq(4)
    end

    it "sets on negative index" do
      a = [1, 2, 3]
      a[-1] = 4
      a[2].should eq(4)
    end
  end

  describe "empty" do
    it "is empty" do
      ([] of Int32).empty?.should be_true
    end

    it "has length 0" do
      ([] of Int32).length.should eq(0)
    end
  end

  describe "==" do
    it "compare empty" do
      ([] of Int32).should eq([] of Int32)
      [1].should_not eq([] of Int32)
      ([] of Int32).should_not eq([1])
    end

    it "compare elements" do
      [1, 2, 3].should eq([1, 2, 3])
      [1, 2, 3].should_not eq([3, 2, 1])
    end
  end

  describe "inspect" do
    assert { [1, 2, 3].inspect.should eq("[1, 2, 3]") }
  end

  describe "+" do
    assert do
      a = [1, 2, 3]
      b = [4, 5]
      c = a + b
      c.length.should eq(5)
      0.upto(4) { |i| c[i].should eq(i + 1) }
    end
  end

  describe "concat" do
    it "concats small arrays" do
      a = [1, 2, 3]
      a.concat([4, 5, 6])
      a.should eq([1, 2, 3, 4, 5, 6])
    end

    it "concats large arrays" do
      a = [1, 2, 3]
      a.concat((4..1000).to_a)
      a.should eq((1..1000).to_a)
    end

    it "concats enumerable" do
      a = [1, 2, 3]
      a.concat((4..1000))
      a.should eq((1..1000).to_a)
    end
  end

  describe "index" do
    it "performs without a block" do
      a = [1, 2, 3]
      a.index(3).should eq(2)
      a.index(4).should be_nil
    end

    it "performs with a block" do
      a = [1, 2, 3]
      a.index { |i| i > 1 }.should eq(1)
      a.index { |i| i > 3 }.should be_nil
    end
  end

  describe "delete_at" do
    it "deletes positive index" do
      a = [1, 2, 3, 4]
      a.delete_at(1).should eq(2)
      a.should eq([1, 3, 4])
    end

    it "deletes negative index" do
      a = [1, 2, 3, 4]
      a.delete_at(-3).should eq(2)
      a.should eq([1, 3, 4])
    end

    it "deletes out of bounds" do
      a = [1, 2, 3, 4]
      expect_raises IndexOutOfBounds do
        a.delete_at(4)
      end
    end
  end

  describe "delete" do
    it "deletes many" do
      a = [1, 2, 3, 1, 2, 3]
      a.delete(2).should be_true
      a.should eq([1, 3, 1, 3])
    end

    it "delete not found" do
      a = [1, 2]
      a.delete(4).should be_false
      a.should eq([1, 2])
    end
  end

  describe "delete_if" do
    it "deletes many" do
      a = [1, 2, 3, 1, 2, 3]
      a.delete_if { |i| i > 2 }
      a.should eq([1, 2, 1, 2])
    end
  end

  describe "&" do
    assert { ([1, 2, 3] & [3, 2, 4]).should eq([2, 3]) }
  end

  describe "|" do
    assert { ([1, 2, 3] | [5, 3, 2, 4]).should eq([1, 2, 3, 5, 4]) }
  end

  describe "-" do
    assert { ([1, 2, 3, 4, 5] - [4, 2]).should eq([1, 3, 5]) }
  end

  describe "clear" do
    assert do
      a = [1, 2, 3]
      a.clear
      a.should eq([] of Int32)
    end
  end

  describe "compact" do
    assert do
      a = [1, nil, 2, nil, 3]
      b = a.compact.should eq([1, 2, 3])
      a.should eq([1, nil, 2, nil, 3])
    end
  end

  describe "compact!" do
    it "returns true if removed" do
      a = [1, nil, 2, nil, 3]
      b = a.compact!.should be_true
      a.should eq([1, 2, 3])
    end

    it "returns false if not removed" do
      a = [1]
      b = a.compact!.should be_false
      a.should eq([1])
    end
  end

  # describe "flatten" do
  #   assert do
  #     a = [[1, 2], 3, [4, [5, 6]]]
  #     a.flatten([] of Int32).should eq([1, 2, 3, 4, 5, 6])
  #     a.should eq([[1, 2], 3, [4, [5, 6]]])
  #   end
  # end

  describe "map" do
    assert do
      a = [1, 2, 3]
      a.map { |x| x * 2 }.should eq([2, 4, 6])
      a.should eq([1, 2, 3])
    end
  end

  describe "map!" do
    assert do
      a = [1, 2, 3]
      a.map! { |x| x * 2 }
      a.should eq([2, 4, 6])
    end
  end

  describe "unshift" do
    assert do
      a = [2, 3]
      expected = [1, 2, 3]
      a.unshift(1).should eq(expected)
      a.should eq(expected)
    end
  end

  describe "insert" do
    it "inserts with positive index" do
      a = [1, 3, 4]
      expected = [1, 2, 3, 4]
      a.insert(1, 2).should eq(expected)
      a.should eq(expected)
    end

    it "inserts with negative index" do
      a = [1, 3, 4]
      expected = [1, 2, 3, 4]
      a.insert(-2, 2).should eq(expected)
      a.should eq(expected)
    end
  end

  describe "reverse" do
    assert do
      a = [1, 2, 3]
      a.reverse.should eq([3, 2, 1])
      a.should eq([1, 2, 3])
    end
  end

  describe "reverse!" do
    assert do
      a = [1, 2, 3, 4, 5]
      a.reverse!
      a.should eq([5, 4, 3, 2, 1])
    end
  end

  describe "uniq!" do
    assert do
      a = [1, 2, 2, 3, 1, 4, 5, 3]
      a.uniq!
      a.should eq([1, 2, 3, 4, 5])
    end

    assert do
      a = [-1, 1, 0, 2, -2]
      a.uniq! { |x| x.abs }
      a.should eq([-1, 0, 2])
    end

    assert do
      a = [1, 2, 3]
      a.uniq! { true }
      a.should eq([1])
    end
  end

  it "raises if out of bounds" do
    expect_raises IndexOutOfBounds do
      [1, 2, 3][4]
    end
  end

  it "has hash" do
    a = [1, 2, [3]]
    b = [1, 2, [3]]
    a.hash.should eq(b.hash)
  end

  describe "pop" do
    it "pops when non empty" do
      a = [1, 2, 3]
      a.pop.should eq(3)
      a.should eq([1, 2])
    end

    it "raises when empty" do
      expect_raises IndexOutOfBounds do
        ([] of Int32).pop
      end
    end

    it "pops many elements" do
      a = [1, 2, 3, 4, 5]
      b = a.pop(3)
      b.should eq([3, 4, 5])
      a.should eq([1, 2])
    end

    it "pops more elements that what is available" do
      a = [1, 2, 3, 4, 5]
      b = a.pop(10)
      b.should eq([1, 2, 3, 4, 5])
      a.should eq([] of Int32)
    end

    it "pops negative count raises" do
      a = [1, 2]
      expect_raises ArgumentError do
        a.pop(-1)
      end
    end
  end

  describe "shift" do
    it "shifts when non empty" do
      a = [1, 2, 3]
      a.shift.should eq(1)
      a.should eq([2, 3])
    end

    it "raises when empty" do
      expect_raises IndexOutOfBounds do
        ([] of Int32).shift
      end
    end

    it "shifts many elements" do
      a = [1, 2, 3, 4, 5]
      b = a.shift(3)
      b.should eq([1, 2, 3])
      a.should eq([4, 5])
    end

    it "shifts more than what is available" do
      a = [1, 2, 3, 4, 5]
      b = a.shift(10)
      b.should eq([1, 2, 3, 4, 5])
      a.should eq([] of Int32)
    end

    it "shifts negative count raises" do
      a = [1, 2]
      expect_raises ArgumentError do
        a.shift(-1)
      end
    end
  end

  describe "first" do
    it "gets first when non empty" do
      a = [1, 2, 3]
      a.first.should eq(1)
    end

    it "raises when empty" do
      expect_raises IndexOutOfBounds do
        ([] of Int32).first
      end
    end
  end

  describe "first?" do
    it "gets first? when non empty" do
      a = [1, 2, 3]
      a.first?.should eq(1)
    end

    it "gives nil when empty" do
      ([] of Int32).first?.should be_nil
    end
  end

  describe "last" do
    it "gets last when non empty" do
      a = [1, 2, 3]
      a.last.should eq(3)
    end

    it "raises when empty" do
      expect_raises IndexOutOfBounds do
        ([] of Int32).last
      end
    end
  end

  describe "sort" do
    it "sort! without block" do
      a = [3, 4, 1, 2, 5, 6]
      a.sort!
      a.should eq([1, 2, 3, 4, 5, 6])
    end

    it "sort without block" do
      a = [3, 4, 1, 2, 5, 6]
      b = a.sort
      b.should eq([1, 2, 3, 4, 5, 6])
      a.should_not eq(b)
    end

    it "sort! with a block" do
      a = ["foo", "a", "hello"]
      a.sort! { |x, y| x.length <=> y.length }
      a.should eq(["a", "foo", "hello"])
    end

    it "sort with a block" do
      a = ["foo", "a", "hello"]
      b = a.sort { |x, y| x.length <=> y.length }
      b.should eq(["a", "foo", "hello"])
      a.should_not eq(b)
    end

    it "sorts by!" do
      a = ["foo", "a", "hello"]
      a.sort_by! &.length
      a.should eq(["a", "foo", "hello"])
    end

    it "sorts by" do
      a = ["foo", "a", "hello"]
      b = a.sort_by &.length
      b.should eq(["a", "foo", "hello"])
      a.should_not eq(b)
    end
  end

  describe "dup" do
    it "duplicate array" do
      x = {1 => 2}
      a = [x]
      b = a.dup
      b.should eq([x])
      a.object_id.should_not eq(b.object_id)
      b << {3 => 4}
      a.should eq([x])
    end
  end

  describe "shuffle" do
    it "shuffle!" do
      a = [1, 2, 3]
      a.shuffle!
      b = [1, 2, 3]
      3.times { a.includes?(b.shift).should be_true }
    end

    it "shuffle" do
      a = [1, 2, 3]
      b = a.shuffle
      a.same?(b).should be_false
      a.should eq([1, 2, 3])

      3.times { b.includes?(a.shift).should be_true }
    end

    it "sample" do
      [1].sample.should eq(1)

      x = [1, 2, 3].sample
      [1, 2, 3].includes?(x).should be_true
    end

    it "gets sample of negative count elements raises" do
      expect_raises ArgumentError do
        [1].sample(-1)
      end
    end

    it "gets sample of 0 elements" do
      [1].sample(0).should eq([] of Int32)
    end

    it "gets sample of 1 elements" do
      [1].sample(1).should eq([1])

      x = [1, 2, 3].sample(1)
      x.length.should eq(1)
      x = x.first
      [1, 2, 3].includes?(x).should be_true
    end

    it "gets sample of k elements out of n" do
      a = [1, 2, 3, 4, 5]
      b = a.sample(3)
      set = Set.new(b)
      set.length.should eq(3)

      set.each do |e|
        a.includes?(e).should be_true
      end
    end

    it "gets sample of k elements out of n, where k > n" do
      a = [1, 2, 3, 4, 5]
      b = a.sample(10)
      b.length.should eq(5)
      set = Set.new(b)
      set.length.should eq(5)

      set.each do |e|
        a.includes?(e).should be_true
      end
    end
  end

  describe "flat_map" do
    it "does example 1" do
      [1, 2, 3, 4].flat_map { |e| [e, -e] }.should eq([1, -1, 2, -2, 3, -3, 4, -4])
    end

    it "does example 2" do
      [[1, 2], [3, 4]].flat_map { |e| e + [100] }.should eq([1, 2, 100, 3, 4, 100])
    end
  end

  describe "product" do
    it "does example 1" do
      r = [] of Int32
      [1,2,3].product([5,6]) { |a, b| r << a; r << b }
      r.should eq([1,5,1,6,2,5,2,6,3,5,3,6])
    end
  end

  describe "swap" do
    it "swaps" do
      a = [1, 2, 3]
      a.swap(0, 2)
      a.should eq([3, 2, 1])
    end

    it "swaps with negative indices" do
      a = [1, 2, 3]
      a.swap(-3, -1)
      a.should eq([3, 2, 1])
    end

    it "swaps but raises out of bounds on left" do
      a = [1, 2, 3]
      expect_raises IndexOutOfBounds do
        a.swap(3, 0)
      end
    end

    it "swaps but raises out of bounds on right" do
      a = [1, 2, 3]
      expect_raises IndexOutOfBounds do
        a.swap(0, 3)
      end
    end
  end

  describe "==" do
    it "compares" do
      a = [1, 2, 3]
      b = [1, 2, 3]
      c = [1, 2, 3, 4]
      d = [1, 2, 4]
      (a == b).should be_true
      (b == c).should be_false
      (a == d).should be_false
    end
  end

  describe "equals?" do
    it "compares with custom block" do
      a = [1, 3, 2]
      b = [3, 9, 4]
      c = [5, 7, 3]
      d = [1, 3, 2, 4]
      f = ->(x : Int32, y : Int32) { (x % 2) == (y % 2) }
      a.equals?(b, &f).should be_true
      a.equals?(c, &f).should be_false
      a.equals?(d, &f).should be_false
    end
  end

  it "does each_index" do
    a = [1, 1, 1]
    b = 0
    a.each_index { |i| b += i }
    b.should eq(3)
  end

  describe "to_s" do
    assert { [1, 2, 3].to_s.should eq("[1, 2, 3]") }

    alias RecursiveArray = Array(RecursiveArray)
    assert do
      ary = [] of RecursiveArray
      ary << ary
      ary.to_s.should eq("[[...]]")
    end
  end
end
