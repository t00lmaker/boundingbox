defmodule Boundingbox do
  @moduledoc """
  Documentation for Boundingbox.
  """
  def main(args) do
    options = load_options(args)
    params_op = Files.file_to_list(options[:params])
    Files.file_to_list(options[:in])
     |> create_pairs()
     |> create_all_bounding_box()
     |> execute_op(options[:op], params_op)
     |> Files.list_to_file(options[:out])
  end

  def load_options(args) do
    { options, _ , _  }= OptionParser.parse(args, [:op, :in, :params, :out])
    op  = options[:op] || "check-point"
    in_  =  options[:in]  || "pairs.csv"
    params =  options[:params]|| "coordinates.csv"
    out  =  options[:out] || "result.csv"
    [in: in_, params: params, out: out, op: op]
  end

  def execute_op(all_bounding, "check-point", params_op) do
    params_op
    |> Enum.map(&(check_in_all_bounding_box(&1, all_bounding)))
    |> Enum.filter(fn (e) -> !Enum.empty?(elem(e,1)) end)
  end

  def execute_op(all_bounding, "origin-dest", params_op) do
    params_op
     |> Enum.chunk(2)
     |> Enum.map(&check_origin_dest(&1, all_bounding))
  end

  def execute_op(_all_bounding, op, _params_op) do
    IO.puts "#{op} is not a valid operation.";
    []
  end

  def create_pairs(pairs) do
    [_ | tail] = pairs
    List.zip([pairs, tail])
    |> Enum.map(&(Tuple.to_list(&1)))
  end

  def create_all_bounding_box(pairs) do
    Enum.map(pairs, fn (pair) ->
      coord1 = List.first(pair)
      coord2 = List.last(pair)
      Coordinate.create_box(coord1, coord2)
    end)
    |> Enum.filter(&Coordinate.valid_box(&1))
  end

  def check_in_all_bounding_box(point, boxes) do
    {point,
      Enum.filter(boxes, fn (box) ->
        Coordinate.point_in_boundingbox(point, box)
    end)}
  end

  def check_origin_dest(origin_dest, boxes) do
    origin = Enum.at(origin_dest, 0)
    dest = Enum.at(origin_dest, 1)
    boxes
    |> Enum.filter(fn (box) ->
      Coordinate.point_in_boundingbox(origin, box) || Coordinate.point_in_boundingbox(dest, box)
    end)
  end

end
