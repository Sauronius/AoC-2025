defmodule DaySix do
  @moduledoc """
  Documentation for 'DaySix' of Advent of Code 2025.

  ## Input files location
  My input files sit in "../../AoC-2025-inputs/inputX.txt" path, so getting solutions
  with 'mix test' requires corrections in day_one_test.exs.

  ## Examples

      iex> DaySix.part_one("path/to/your/input")
      5060053676136

      iex> DaySix.part_two("path/to/your/input")
      9695042567249
  """

  def prepare_file(path) do
    path
    |> File.read!()
    |> String.trim_trailing("\n")
    |> String.split("\n")
  end

  def ignore_alignment(worksheet) do
    worksheet
    |> Enum.map(&String.split(&1, ~r/\s+/, trim: true))
    |> Enum.zip()
    |> Enum.map(fn column -> column |> Tuple.to_list() |> Enum.reverse() end)
  end

  def save_alignment(worksheet) do
    split_positions = worksheet
    |> Enum.map(&Regex.scan(~r/\s{1}[\*\+]{1}/, &1, return: :index))
    |> List.flatten()
    |> Enum.map(&elem(&1, 0))

    worksheet
    |> Enum.map(&multi_split(split_positions, 0, &1, [], false))
    |> Enum.zip()
    |> Enum.map(fn column -> column |> Tuple.to_list() |> Enum.reverse() |> correct_last_line() end)
  end

  def part_one(path) do
    path
    |> prepare_file()
    |> ignore_alignment()
    |> grand_total()
  end

  def part_two(path) do
    path
    |> prepare_file()
    |> save_alignment()
    |> Enum.map(&correct_numbers/1)
    |> grand_total()
  end

  defp grand_total(worksheet), do: Enum.reduce(worksheet, 0, fn column, acc -> acc + column_total(column) end)

  defp column_total(["*" | rest_of_column]) , do: rest_of_column |> Enum.map(&String.to_integer/1) |> Enum.product()
  defp column_total(["+" | rest_of_column]) , do: rest_of_column |> Enum.map(&String.to_integer/1) |> Enum.sum()

  defp correct_numbers([sign | numbers]) do
    max_digits = numbers
    |> Enum.max_by(&String.length/1)
    |> String.length()

    proper_number_list = numbers
    |> Enum.map(&String.codepoints/1)
    |> Enum.zip()
    |> Enum.map(&(&1 |> Tuple.to_list() |> Enum.reverse() |> Enum.join() |> String.trim()))

    [sign | proper_number_list]
  end

  defp multi_split([], _, _, result, true), do: result
  defp multi_split([], start_position, string_to_split, result, false) do
    string_fragment = String.slice(string_to_split, start_position..-1//1)
    if String.contains?(string_fragment, "*") or String.contains?(string_fragment, "+") do
      multi_split([], start_position, string_to_split, [String.trim(string_fragment) | result], true)
    else
      multi_split([], start_position, string_to_split, [string_fragment | result], true)
    end
  end
  defp multi_split([index | index_list], start_position, string_to_split, result, flag) do
    string_fragment = String.slice(string_to_split, start_position..index - 1)
    if String.contains?(string_fragment, "*") or String.contains?(string_fragment, "+") do
      multi_split(index_list, index + 1, string_to_split, [String.trim(string_fragment) | result], flag)
    else
      multi_split(index_list, index + 1, string_to_split, [string_fragment | result], flag)
    end
  end

  defp correct_last_line([sign | numbers]) do
    desired_length = String.length(Enum.max_by(numbers, &String.length/1))
    corrected_last_line = Enum.map(numbers, &(&1 <> String.duplicate(" ", desired_length - String.length(&1))))
    [sign | corrected_last_line]
  end
end
