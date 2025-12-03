defmodule DayThree do
  @moduledoc """
  Documentation for 'DayThree' of Advent of Code 2025.

  ## Input files location
  My input files sit in "../../AoC-2025-inputs/inputX.txt" path, so getting solutions
  with 'mix test' requires corrections in day_one_test.exs.

  ## Examples

      iex> DayThree.part_one("path/to/your/input")
      17301

      iex> DayThree.part_two("path/to/your/input")
      172162399742349
  """

  def prepare_file(path) do
    path
    |> File.read!()
    |> String.trim_trailing("\n")
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  def part_one(path) do
    path
    |> prepare_file()
    |> Enum.map(&(largest_2_battery_joltage(&1, "0", "0")))
    |> Enum.sum()
  end

  def part_two(path) do
    path
    |> prepare_file()
    |> Enum.map(&(largest_12_battery_joltage(&1, [], 0, 12)))
    |> Enum.sum()
  end

  defp largest_2_battery_joltage([], max_first, max_second), do: max_first <> max_second |> String.to_integer()
  defp largest_2_battery_joltage([battery | []], max_first, max_second) do
    cond do
      battery > max_second -> largest_2_battery_joltage([], max_first, battery)
      true -> largest_2_battery_joltage([], max_first, max_second)
    end
  end
  defp largest_2_battery_joltage([battery | rest_of_bank], max_first, max_second) when battery > max_first do
    largest_2_battery_joltage(rest_of_bank, battery, "0")
  end
  defp largest_2_battery_joltage([battery | rest_of_bank], max_first, max_second) when battery > max_second do
    largest_2_battery_joltage(rest_of_bank, max_first, battery)
  end
  defp largest_2_battery_joltage([_battery | rest_of_bank], max_first, max_second) do
    largest_2_battery_joltage(rest_of_bank, max_first, max_second)
  end

  defp largest_12_battery_joltage(_batteries, joltage, _range_start, 0), do: joltage |> Enum.reverse() |> Enum.join("") |> String.to_integer()
  defp largest_12_battery_joltage(batteries, joltage, range_start, range_limit) do
    search_area = Enum.slice(batteries, range_start..-range_limit//1)
    highest_rating_battery = Enum.max(search_area)

    largest_12_battery_joltage(batteries, [highest_rating_battery | joltage], Enum.find_index(search_area, &(&1 == highest_rating_battery)) + 1 + range_start, range_limit - 1)
  end
end
