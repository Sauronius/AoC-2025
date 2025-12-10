defmodule DayNine do
  @moduledoc """
  Documentation for 'DayNine' of Advent of Code 2025.

  ## Input files location
  My input files sit in "../../AoC-2025-inputs/inputX.txt" path, so getting solutions
  with 'mix test' requires corrections in day_one_test.exs.

  ## Examples

      iex> DayNine.part_one("path/to/your/input")
      4781377701

      iex> DayNine.part_two("path/to/your/input")
      1470616992
  """

  def prepare_file(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn string_corners -> string_corners |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple() end)
  end

  def part_one(path) do
    red_tiles = prepare_file(path)
    find_largest_rectangle(red_tiles, red_tiles)
  end

  def part_two(path) do
    red_tiles = prepare_file(path)
    edges = create_edges(red_tiles ++ [List.first(red_tiles)])
    find_largest_rectangle(red_tiles, red_tiles, edges)
  end

  defp find_largest_rectangle(tiles, red_tiles, edges \\ [], largest_rectangle \\ 0)
  defp find_largest_rectangle([_red_tile | []], red_tiles, _edges, largest_rectangle), do: largest_rectangle
  defp find_largest_rectangle([red_tile | rest_of_tiles], red_tiles, edges, largest_rectangle) do
    largest_rectangle_in_group = for opposite_tile <- rest_of_tiles,
      inbound?(edges, min_max_of_rectangle(red_tile, opposite_tile)) do
        area_of_rectangle(red_tile, opposite_tile)
      end
    |> Enum.max()

    find_largest_rectangle(rest_of_tiles, red_tiles, edges, max(largest_rectangle, largest_rectangle_in_group))
  end

  defp area_of_rectangle({x1, y1}, {x2, y2}), do: (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)

  defp create_edges(tiles, previous_tile \\ {}, edges \\ [])
  defp create_edges([], _first_tile, edges), do: edges
  defp create_edges([tile | tiles], {}, edges), do: create_edges(tiles, tile, edges)
  defp create_edges([{x2, y2} = tile | tiles], {x1, y1} = previous_tile, edges) do
    if x1 == x2 do
        create_edges(tiles, tile, [{x1, min(y1, y2)..max(y1, y2)} | edges])
    else
        create_edges(tiles, tile, [{min(x1, x2)..max(x1, x2), y2} | edges])
    end
  end

  defp inbound?(edges, rectangle_min_max, inbound \\ true)
  defp inbound?([], _, inbound), do: inbound
  defp inbound?(_, _, false), do: false
  defp inbound?([{edge_x_min..edge_x_max, edge_y} | edges], {min_x, max_x, min_y, max_y} = rectangle_min_max, inbound) do
    if edge_y < min_y + 1 or edge_y > max_y - 1 or edge_x_max < min_x + 1 or edge_x_min > max_x - 1 do
      inbound?(edges, rectangle_min_max, inbound)
    else
      inbound?(edges, rectangle_min_max, false)
    end
  end
  defp inbound?([{edge_x, edge_y_min..edge_y_max} | edges], {min_x, max_x, min_y, max_y} = rectangle_min_max, inbound) do
    if edge_y_max < min_y + 1 or edge_y_min > max_y - 1 or edge_x < min_x + 1 or edge_x > max_x - 1 do
      inbound?(edges, rectangle_min_max, inbound)
    else
      inbound?(edges, rectangle_min_max, false)
    end
  end

  defp min_max_of_rectangle({x1, y1}, {x2, y2}), do: {min(x1, x2), max(x1, x2), min(y1, y2), max(y1, y2)}
end
