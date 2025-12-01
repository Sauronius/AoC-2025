defmodule DayOne do
  @moduledoc """
  Documentation for 'DayOne' of Advent of Code 2025.

  ## Input files location
  My input files sit in "../../AoC-2025-inputs/inputX.txt" path, so getting solutions
  with 'mix test' requires corrections in day_one_test.exs.

  ## Examples

      iex> DayOne.part_one("path/to/your/input")
      1102

      iex> DayOne.part_two("path/to/your/input")
      6175
  """
  @hundred_range 0..99//1

  def prepare_file(path) do
    path
    |> File.read!()
    |> String.trim_trailing("\n")
    |> String.split("\n")
    |> Enum.map(&String.split_at(&1, 1))
    |> Enum.map(fn {direction, string_distance} -> distance = {direction, String.to_integer(string_distance)} end)
  end

  def part_one(path) do
    path
    |> prepare_file()
    |> Enum.reduce({50, 0}, fn rotation, acc -> {new_number, _} = turn_dial(elem(acc, 0), rotation)
      if new_number == 0 do
        {new_number, elem(acc, 1) + 1}
      else
        {new_number, elem(acc, 1)}
      end end)
    |> elem(1)
  end

  def part_two(path) do
    path
    |> prepare_file()
    |> execute_rotations(50, 0)
    |> elem(1)
  end

  defp execute_rotations([], number, acc), do: {number, acc}
  defp execute_rotations([{"L", distance} | rest], number, acc) do
    all_clicks = Stream.cycle(@hundred_range)
    |> Enum.take((div(distance, 100) + 1) * 100 + number)
    |> Enum.slice(-distance..-1//1)

    new_number = List.first(all_clicks)
    zeros = Enum.count(all_clicks, fn x -> x == 0 end)
    execute_rotations(rest, new_number, acc + zeros)
  end
  defp execute_rotations([{"R", distance} | rest], number, acc) do
    all_clicks = Stream.cycle(@hundred_range)
    |> Enum.take(distance + number + 1)
    |> Enum.slice(number + 1..-1//1)

    new_number = List.last(all_clicks)
    zeros = Enum.count(all_clicks, fn x -> x == 0 end)
    execute_rotations(rest, new_number, acc + zeros)
  end

  defp turn_dial(start_number, {"L", distance}), do: if( (new_number = start_number - rem(distance, 100)) < 0, do: {new_number + 100, 1}, else: {new_number, 0})
  defp turn_dial(start_number, {"R", distance}), do: if( (new_number = start_number + rem(distance, 100)) > 99, do: {new_number - 100, 1}, else: {new_number, 0})
end
