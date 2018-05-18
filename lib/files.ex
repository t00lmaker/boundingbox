defmodule Files do
    @moduledoc """
    Documentation for Files.
    """

    @doc """
    Hello world.

    ## Examples

        iex> Boundingbox.hello
        :world

    """

    @main_path "sources"

    def file_to_list(file_path) do
        case File.open( "#{@main_path}/#{file_path}") do
            {:ok, file} ->
              IO.binstream(file, :line)
                |> Stream.map(&(String.replace(&1, "\n", "")) )
                |> Stream.map(&(String.split(&1,",")))
                |> Stream.map(&List.to_tuple(&1))
                |> Enum.drop(1)
                |> Enum.map(fn(line_tuple) ->
                 {val1, _ } = Float.parse(elem(line_tuple, 0))
                 {val2, _ } = Float.parse(elem(line_tuple, 1))
                 Coordinate.create(val1, val2)
                end)
            {:error,reason} ->
                :file.format_error(reason)
        end
    end

    def list_to_file(list, file_path) do
        file_path = "#{@main_path}/#{file_path}"
        list
        |> Stream.map(&(inspect(&1) <> "\n"))
        |> Stream.into(File.stream!(file_path,[:write, :utf8]))
        |> Stream.run
    end
end
