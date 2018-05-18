defmodule CoordinateTest do
  use ExUnit.Case
  doctest Coordinate

  test "create must return a tuple with two values in order" do
    assert Coordinate.create(1,2) == {1,2}
  end

  test "create must not return to tuple with two values in inverse order" do
    refute Coordinate.create(1,2) == {2,1}
  end

  test "x must return to the first coordinate position" do
    assert Coordinate.x({1,2}) == 1
  end

  test "x must not return to the last coordinate position" do
    refute Coordinate.x({1,2}) == 2
  end

  test "y must return to the last coordinate position" do
    assert Coordinate.y({1,2}) == 2
  end

  test "y must not return to the first coordinate position" do
    refute Coordinate.y({1,2}) == 1
  end

  test "valid_box must ensure that the extremes must have different Y" do
    assert Coordinate.valid_box([{120.99562, 14.51318}, {120.99562, 14.51064}, {120.99506000000001, 14.51064}, {120.99506000000001, 14.51318}])
    refute Coordinate.valid_box([{120.99562, 14.51318}, {120.99562, 14.51318}, {120.99506000000001, 14.51318}, {120.99506000000001, 14.51318}])
    refute Coordinate.valid_box([{120.99562, 14.51318}, {120.99562, 14.51318}, {120.99562, 14.51318}, {120.99506000000001, 14.51318}])
    refute Coordinate.valid_box([{120.99562, 14.51318}, {120.99562, 14.51318}, {120.99506000000001, 14.51318}, {120.99506000000001, 14.51318}])
  end

  test "create_box must create a box with four coordinates" do
   box = Coordinate.create_box({120.99562, 14.51318}, {120.99506000000001, 14.51064})
   assert length(box) == 4
  end

  test "create_box must create a box with coordinates params in extremes" do
   box = Coordinate.create_box({120.99562, 14.51318}, {120.99506000000001, 14.51064})
   assert Enum.at(box,0) == {120.99562, 14.51318}
   refute Enum.at(box,1) == {120.99562, 14.51318}
   assert Enum.at(box,2) == {120.99506000000001, 14.51064}
   refute Enum.at(box,3) == {120.99506000000001, 14.51064}
  end

  test "create_box must create boxes with complementary coordinates with x1, y2, x2, y1" do
   box = Coordinate.create_box({120.99562, 14.51318}, {120.99506000000001, 14.51064})
   assert Enum.at(box,1) == {120.99562, 14.51064}
   assert Enum.at(box,3) == {120.99506000000001, 14.51318}
  end

  test "dot must return calc from x(param1) * x(param2) + y(param1) * y(param2)" do
    assert Coordinate.dot({1,2},{3,4}) == 11
    assert Coordinate.dot({1,4},{3,4}) == 19
  end

  test "vector must create a coordinate with x = x(coord2) - x(coord1) and y = y(coord2) - y(coord1)" do
    assert Coordinate.vector({1,2},{3,4}) == {2, 2}
    assert Coordinate.vector({1,4},{3,4}) == {2, 0}
  end

  test "point_in_boundingbox must check if point in a box" do
    assert Coordinate.point_in_boundingbox({120.9956, 14.5126}, [{120.99562, 14.51318}, {120.99562, 14.51064}, {120.99506000000001, 14.51064}, {120.99506000000001, 14.51318}])
    refute Coordinate.point_in_boundingbox({121.9956, 14.5126}, [{120.99562, 14.51318}, {120.99562, 14.51064}, {120.99506000000001, 14.51064}, {120.99506000000001, 14.51318}])
  end

end
