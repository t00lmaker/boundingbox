defmodule BoundingboxTest do
  use ExUnit.Case
  doctest Boundingbox

  test "load_options must load default options if no option" do
    options = Boundingbox.load_options([])
    assert options[:in] == "pairs.csv"
    assert options[:params] == "coordinates.csv"
    assert options[:out] == "result.csv"
    assert options[:op] ==  "check-point"
  end

  test "load_options must load options options" do
    options = Boundingbox.load_options(["--in","1","--params","2","--out","3","--op","4"])
    assert options[:in] == "1"
    assert options[:params] == "2"
    assert options[:out] == "3"
    assert options[:op] ==  "4"
  end

  test "create_pairs must combination a list (1,2,3,4...) this way [1,2])[2,3][3,4]..." do
    pairs = Boundingbox.create_pairs([{1,1},{2,2},{3,3},{4,4}])
    assert Enum.at(pairs, 0) == [{1,1},{2,2}]
    assert Enum.at(pairs, 1) == [{2,2},{3,3}]
    assert Enum.at(pairs, 2) == [{3,3},{4,4}]
  end

  test "create_all_bounding_box must create only valid boxes" do
    pairs = [[{1,1},{4,4}], [{1,2},{5,8}], [{1,2},{5,2}],[{1,2},{1,8}]]
    boxes = Boundingbox.create_all_bounding_box(pairs)
    assert Enum.member?(boxes, [{1, 1}, {1, 4}, {4, 4}, {4, 1}])
    assert Enum.member?(boxes, [{1, 2}, {1, 8}, {5, 8}, {5, 2}])
    refute Enum.member?(boxes, [{1, 2}, {1, 2}, {5, 2}, {5, 2}]) #invalid box
    refute Enum.member?(boxes, [{1, 2}, {1, 8}, {1, 8}, {1, 2}]) #invalid box
  end

  test "check_in_all_bounding_box must check if point is same of all bounding_box" do
    boxes = [
      [{120.99324000000004, 14.636650000000003}, {120.99324000000004, 14.626190000000003}, {120.98974000000004, 14.626190000000003}, {120.98974000000004, 14.636650000000003}],
      [{120.99562, 14.51318}, {120.99562, 14.51064}, {120.99506000000001, 14.51064}, {120.99506000000001, 14.51318}]
    ]
    assert Boundingbox.check_in_all_bounding_box({120.9956, 14.5126}, boxes) == {{120.9956, 14.5126}, [Enum.at(boxes,1)]}
    assert Boundingbox.check_in_all_bounding_box({120.9917, 14.6364}, boxes) == {{120.9917, 14.6364}, [Enum.at(boxes,0)]}
    assert Boundingbox.check_in_all_bounding_box({121.9917, 15.0012}, boxes) == {{121.9917, 15.0012}, []}
  end

  test "check_origin_dest must identify boxes from origin and destination" do
    boxes = [
      [{120.99324000000004, 14.636650000000003}, {120.99324000000004, 14.626190000000003}, {120.98974000000004, 14.626190000000003}, {120.98974000000004, 14.636650000000003}],
      [{120.99562, 14.51318}, {120.99562, 14.51064}, {120.99506000000001, 14.51064}, {120.99506000000001, 14.51318}],
      [{121.00115999999998, 14.475110000000003}, {121.00115999999998, 14.473830000000003}, {120.99969999999999, 14.473830000000003}, {120.99969999999999, 14.475110000000003}],
      [{120.99795999999999, 14.471230000000006}, {120.99795999999999, 14.469610000000005}, {120.99708999999999, 14.469610000000005}, {120.99708999999999, 14.471230000000006}]
    ]
    origin_dest_pair = [{120.9917, 14.6364}, {120.9971, 14.4704}]
    assert Boundingbox.check_origin_dest(origin_dest_pair, boxes) == [Enum.at(boxes, 0), Enum.at(boxes, 3)]
  end

  test "check_origin_dest must return only one box, if origin and destination in one only box" do
    boxes = [
      [{120.99324000000004, 14.636650000000003}, {120.99324000000004, 14.626190000000003}, {120.98974000000004, 14.626190000000003}, {120.98974000000004, 14.636650000000003}],
      [{120.99562, 14.51318}, {120.99562, 14.51064}, {120.99506000000001, 14.51064}, {120.99506000000001, 14.51318}],
      [{121.00115999999998, 14.475110000000003}, {121.00115999999998, 14.473830000000003}, {120.99969999999999, 14.473830000000003}, {120.99969999999999, 14.475110000000003}],
      [{120.99795999999999, 14.471230000000006}, {120.99795999999999, 14.469610000000005}, {120.99708999999999, 14.469610000000005}, {120.99708999999999, 14.471230000000006}]
    ]
    origin_dest_pair = [{120.9917, 14.6364}, {120.98974000000004, 14.626190000000003}]
    assert Boundingbox.check_origin_dest(origin_dest_pair, boxes) == [Enum.at(boxes, 0)]
  end

end
