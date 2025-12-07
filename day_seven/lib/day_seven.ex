defmodule DaySeven do
  @moduledoc """
  Documentation for 'DaySeven' of Advent of Code 2025.

  ## Input files location
  My input files sit in "../../AoC-2025-inputs/inputX.txt" path, so getting solutions
  with 'mix test' requires corrections in day_one_test.exs.

  ## Examples

      iex> DaySix.part_one("path/to/your/input")
      1566

      iex> DaySix.part_two("path/to/your/input")
      5921061943075
  """

  def prepare_file(path) do
    path
    |> File.read!()
    |> String.trim_trailing("\n")
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y_index} -> indexed_row = row |> String.codepoints() |> Enum.with_index()
        for {element, x_index} <- indexed_row, do: {{x_index, y_index}, element} end)
    |> Map.new()
  end

  def part_one(path) do
    tachyon_manifold_map = prepare_file(path)
    {start_x, start_y} = Enum.find_value(tachyon_manifold_map, fn {position, value} -> if value == "S", do: position end)
    {{_, max_y}, _} = Enum.max_by(tachyon_manifold_map, fn {{_, y}, _} -> y end)

    tachyon_manifold_map
    |> locate_splitters(start_y, max_y, [start_x], [])
    |> Enum.sum()
  end

  def part_two(path) do
    :ets.new(:day_seven, [:set, :public, :named_table, read_concurrency: true, write_concurrency: true])

    tachyon_manifold_map = prepare_file(path)
    {start_x, start_y} = Enum.find_value(tachyon_manifold_map, fn {position, value} -> if value == "S", do: position end)
    {{_, max_y}, _} = Enum.max_by(tachyon_manifold_map, fn {{_, y}, _} -> y end)

    tachyon_manifold_map
    |> count_timelines(start_y, max_y, start_x)
  end

  defp locate_splitters(_, current_depth, max_map_depth, _, splitters_count) when current_depth > max_map_depth, do: splitters_count
  defp locate_splitters(tachyon_manifold_map, current_depth, max_map_depth, beam_paths, splitters_count) do
    {updated_beam_paths, found_splitters} = for path <- beam_paths do
      if tachyon_manifold_map[{path, current_depth}] == "^" do
        {{path - 1, path + 1}, 1}
      else
        {path, 0}
      end
    end
    |> Enum.map_reduce(0, fn element, acc -> case element do
        {{p1, p2}, value} -> {[p1, p2], acc + value}
        {path, value} -> {path, acc + value}
        end
      end)

    clean_updated_beam_paths = updated_beam_paths
    |> List.flatten()
    |> Enum.uniq()
    locate_splitters(tachyon_manifold_map, current_depth + 1, max_map_depth, clean_updated_beam_paths, [found_splitters | splitters_count])
  end

  defp count_timelines(_, current_depth, max_map_depth, _beam_path) when current_depth > max_map_depth, do: 1
  defp count_timelines(tachyon_manifold_map, current_depth, max_map_depth, beam_path) do
    cond do
      (cached_result = get_from_cache(:day_seven, {current_depth, beam_path})) != nil -> cached_result
      tachyon_manifold_map[{beam_path, current_depth}] == "^" -> put_into_cache(:day_seven, {current_depth, beam_path}, count_timelines(tachyon_manifold_map, current_depth + 1, max_map_depth, beam_path - 1) + count_timelines(tachyon_manifold_map, current_depth + 1, max_map_depth, beam_path + 1))
        count_timelines(tachyon_manifold_map, current_depth + 1, max_map_depth, beam_path - 1) + count_timelines(tachyon_manifold_map, current_depth + 1, max_map_depth, beam_path + 1)
      true -> put_into_cache(:day_seven, {current_depth, beam_path}, count_timelines(tachyon_manifold_map, current_depth + 1, max_map_depth, beam_path))
        count_timelines(tachyon_manifold_map, current_depth + 1, max_map_depth, beam_path)
    end
  end

  defp get_from_cache(name, key) do
    case :ets.lookup(name, key) do
      [{_key, value}] -> value
      _ -> nil
    end
  end

  defp put_into_cache(name, key, value) do
    :ets.insert(name, {key, value})
  end
end
