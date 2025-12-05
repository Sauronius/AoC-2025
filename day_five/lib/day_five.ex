defmodule DayFive do
  @moduledoc """
  Documentation for 'DayFive' of Advent of Code 2025.

  ## Input files location
  My input files sit in "../../AoC-2025-inputs/inputX.txt" path, so getting solutions
  with 'mix test' requires corrections in day_one_test.exs.

  ## Examples

      iex> DayFive.part_one("path/to/your/input")
      701

      iex> DayFive.part_two("path/to/your/input")
      352340558684863
  """

  def prepare_file(path) do
    [fresh_ranges_string, available_ids_string] = path
    |> File.read!()
    |> String.trim_trailing("\n")
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))

    fresh_ingredient_id_ranges = fresh_ranges_string
    |> Enum.map(fn x -> [range_start, range_end] = x
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

      Range.new(range_start, range_end)
      end)
    |> Enum.uniq()

    available_ids = Enum.map(available_ids_string, &String.to_integer/1)
    {fresh_ingredient_id_ranges, available_ids}
  end

  def part_one(path) do
    {fresh_ingredient_id_ranges, available_ids} = prepare_file(path)
    for id <- available_ids do
      if Enum.any?(fresh_ingredient_id_ranges, &Enum.member?(&1, id)), do: 1, else: 0
    end
    |> Enum.sum()
  end

  def part_two(path) do
    {fresh_ingredient_id_ranges, _available_ids} = prepare_file(path)
    reduce_ranges(fresh_ingredient_id_ranges, [])
    |> Enum.reduce(0, fn range, acc -> range |> Enum.count() |> Kernel.+(acc) end)
  end

  defp reduce_ranges([], reduced_ranges), do: reduced_ranges
  defp reduce_ranges([range | range_list], reduced_ranges) do
    {new_range_list, changes} = Enum.map_reduce(range_list, 0, fn second_range, acc -> if Range.disjoint?(range, second_range), do: {second_range, acc}, else: {join_ranges(range, second_range), acc + 1} end)
    if changes == 0 do
      reduce_ranges(range_list, [range | reduced_ranges])
    else
      reduce_ranges(new_range_list, reduced_ranges)
    end
  end

  defp join_ranges(r1_s..r1_e//1, r2_s..r2_e//1) do
    Range.new(min(r1_s, r2_s), max(r1_e, r2_e))
  end
end
