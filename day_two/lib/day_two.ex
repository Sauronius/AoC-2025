defmodule DayTwo do
  @moduledoc """
  Documentation for 'DayTwo' of Advent of Code 2025.

  ## Input files location
  My input files sit in "../../AoC-2025-inputs/inputX.txt" path, so getting solutions
  with 'mix test' requires corrections in day_one_test.exs.

  ## Examples

      iex> DayTwo.part_one("path/to/your/input")
      56660955519

      iex> DayTwo.part_two("path/to/your/input")
      79183223243
  """

  def prepare_file(path) do
    path
    |> File.read!()
    |> String.trim_trailing("\n")
    |> String.split(",")
    |> Enum.map(fn string_ids -> string_ids
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)
      |> range_from_list_pair() end)
  end

  def part_one(path) do
    path
    |> prepare_file()
    |> Enum.map(fn id_range -> for id <- id_range, do: validate_id(id) end)
    |> List.flatten()
    |> Enum.sum()
  end

  def part_two(path) do
    path
    |> prepare_file()
    |> Enum.map(fn id_range -> for id <- id_range, do: validate_id_2(id) end)
    |> List.flatten()
    |> Enum.sum()
  end

  defp validate_id_2(number) do
    digits = (trunc(:math.log10(number) + 1))
    dividers = Enum.filter(1..5, &(rem(digits, &1) == 0))
    integer_digits = Integer.digits(number)
    invalid_flag = for divider <- dividers do
      chunk_size = div(digits, divider)
      if chunk_size == 1 or chunk_size == digits or digits == 2 do
        integer_digits
        |> Enum.dedup()
        |> Enum.count()
        |> Kernel.==(1)
      else
        Enum.chunk_every(integer_digits, div(digits, divider))
      end
    end
    |> Enum.map(&invalid?/1)
    |> Enum.any?()
    if !invalid_flag or digits == 1, do: 0, else: number
  end

  defp validate_id(number) do
    cond do
      rem(trunc(:math.log10(number) + 1), 2) == 0 -> if is_invalid_id?(number), do: number, else: 0
      true -> 0
    end
  end

  defp range_from_list_pair([value1, value2]), do: Range.new(value1, value2)

  defp is_invalid_id?(number) do
    half_length = div(trunc(:math.log10(number) + 1), 2)
    {first_half, second_half} = number
    |> Integer.to_string()
    |> String.split_at(half_length)

    String.equivalent?(first_half, second_half)
  end

  defp invalid?(true), do: true
  defp invalid?(false), do: false
  defp invalid?([p1, p2]) do
    [p1, p2]
    |> Enum.zip_with(fn [x, y] -> x == y end)
    |> Enum.all?()
  end
  defp invalid?([p1, p2, p3]) do
    [p1, p2, p3]
    |> Enum.zip_with(fn [x, y, z] -> length(Enum.dedup([x, y, z])) == 1 end)
    |> Enum.all?()
  end
  defp invalid?([p1, p2, p3, p4]) do
    [p1, p2, p3, p4]
    |> Enum.zip_with(fn [x, y, z, a] -> length(Enum.dedup([x, y, z, a])) == 1 end)
    |> Enum.all?()
  end
  defp invalid?([p1, p2, p3, p4, p5]) do
    [p1, p2, p3, p4, p5]
    |> Enum.zip_with(fn [x, y, z, a, b] -> length(Enum.dedup([x, y, z, a, b])) == 1 end)
    |> Enum.all?()
  end
end
