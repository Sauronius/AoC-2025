defmodule DayFour do
  @moduledoc """
  Documentation for 'DayFour' of Advent of Code 2025.

  ## Input files location
  My input files sit in "../../AoC-2025-inputs/inputX.txt" path, so getting solutions
  with 'mix test' requires corrections in day_one_test.exs.

  ## Examples

      iex> DayFour.part_one("path/to/your/input")
      1604

      iex> DayFour.part_two("path/to/your/input")
      9397
  """

  def prepare_file(path) do
    path
    |> File.read!()
    |> String.trim_trailing("\n")
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index(fn row, y_index -> for {element, x_index} <- row, do: {{x_index, y_index}, element} end)
    |> List.flatten()
    |> Map.new()
  end

  def part_one(path) do
    path
    |> prepare_file()
    |> find_rolls_of_paper()
    |> length()
  end

  def part_two(path) do
    path
    |> prepare_file()
    |> find_rolls_of_paper_rec(0, true)
  end

  defp find_rolls_of_paper(locations_map) do
    offsets = for x_o <- -1..1, y_o <- -1..1 do
       {x_o, y_o}
    end
    |> List.delete({0, 0})

    for {coord, element} <- locations_map, element == "@" do
      adjacent_rolls = for offset <- offsets do
        coords_to_check = add_offset_to_coordinates(coord, offset)
        if locations_map[coords_to_check] == "@", do: 1, else: 0
      end

      if Enum.sum(adjacent_rolls) < 4, do: coord
    end
    |> Enum.filter(&(&1 != nil))
  end

  defp find_rolls_of_paper_rec(_locations_map, total_accessible, false), do: total_accessible
  defp find_rolls_of_paper_rec(locations_map, total_accessible, true) do
    accessible_rolls = find_rolls_of_paper(locations_map)
    number_of_accessible_rolls = length(accessible_rolls)
    new_locations_map = accessible_rolls
    |> Map.from_keys(".")
    |> Map.merge(locations_map, fn _k, v1, _v2 -> v1 end)
    |> find_rolls_of_paper_rec(total_accessible + number_of_accessible_rolls, number_of_accessible_rolls != 0)
  end

  defp add_offset_to_coordinates({x_coord, y_coord}, {x_offset, y_offset}), do: {x_coord + x_offset, y_coord + y_offset}
end
