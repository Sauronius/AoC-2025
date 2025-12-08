defmodule DayEight do
  @moduledoc """
  Documentation for 'DayEight' of Advent of Code 2025.

  ## Input files location
  My input files sit in "../../AoC-2025-inputs/inputX.txt" path, so getting solutions
  with 'mix test' requires corrections in day_one_test.exs.

  ## Examples

      iex> DayEight.part_one("path/to/your/input")
      135169

      iex> DayEight.part_two("path/to/your/input")
      302133440
  """

  def prepare_file(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn string_box -> string_box |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple() end)
  end

  def part_one(path, pair_limit \\ 1000) do
    path
    |> prepare_file()
    |> map_closest_distance()
    |> Enum.sort_by(fn {_, {distance, _}} -> distance end)
    |> Enum.uniq_by(fn {{x1, y1, z1}, {_, {x2, y2, z2}}} -> {x1 * x2, y1 * y2, z1 * z2} end)
    |> create_circuits(pair_limit)
    |> Enum.map(&length/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def part_two(path) do
    junction_boxes = prepare_file(path)
    limit = length(junction_boxes)
    junction_boxes
    |> map_closest_distance()
    |> Enum.sort_by(fn {_, {distance, _}} -> distance end)
    |> Enum.uniq_by(fn {{x1, y1, z1}, {_, {x2, y2, z2}}} -> {x1 * x2, y1 * y2, z1 * z2} end)
    |> create_circuits(limit, limit + 1)
    |> distance_from_the_wall()
  end

  defp map_closest_distance(junction_boxes) do
    for junction_box <- junction_boxes do
      junction_boxes
      |> Enum.map(fn other_box -> {euclidean_distance(other_box, junction_box), other_box} end)
      |> Enum.sort_by(fn {distance, _} -> distance end)
      |> Enum.filter(fn {distance, _} -> distance != 0 end)
      |> Enum.map(&({junction_box, &1}))
    end
    |> List.flatten()
  end

  defp create_circuits(_, limit, number_of_pairs \\ 0, circuits \\ [], latest_pair \\ {})
  defp create_circuits(_, limit, _number_of_pairs, [circuits], latest_pair) when length(circuits) == limit, do: latest_pair
  defp create_circuits(_, limit, number_of_pairs, circuits, _latest_pair) when number_of_pairs == limit, do: circuits
  defp create_circuits([{junction_box, {_, closest_neighbour}} | junction_boxes], limit, number_of_pairs, circuits, _latest_pair) do
    cond do
      !Enum.any?(circuits, &(junction_box in &1)) and !Enum.any?(circuits, &(closest_neighbour in &1)) -> create_circuits(junction_boxes, limit, number_of_pairs + 1, [[junction_box, closest_neighbour] | circuits], {junction_box, closest_neighbour})
      Enum.any?(circuits, &(junction_box in &1)) and Enum.any?(circuits, &(closest_neighbour in &1)) ->
        circuit_1 = Enum.find(circuits, &(junction_box in &1))
        circuit_2 = Enum.find(circuits, &(closest_neighbour in &1))
        if circuit_1 == circuit_2 do
          create_circuits(junction_boxes, limit, number_of_pairs + 1, circuits, {junction_box, closest_neighbour})
        else
          updated_circuit = Enum.reject(circuits, &(&1 == circuit_1 or &1 == circuit_2))
          create_circuits(junction_boxes, limit, number_of_pairs + 1, [Enum.concat(circuit_1, circuit_2) | updated_circuit], {junction_box, closest_neighbour})
        end
      Enum.any?(circuits, &(junction_box in &1)) -> updated_circuits = Enum.map(circuits, fn circuit -> if junction_box in circuit, do: [closest_neighbour | circuit], else: circuit end)
        create_circuits(junction_boxes, limit, number_of_pairs + 1, updated_circuits, {junction_box, closest_neighbour})
      true -> updated_circuits = Enum.map(circuits, fn circuit -> if closest_neighbour in circuit, do: [junction_box | circuit], else: circuit end)
        create_circuits(junction_boxes, limit, number_of_pairs + 1, updated_circuits, {junction_box, closest_neighbour})
    end
  end

  defp euclidean_distance({x1, y1, z1}, {x2, y2, z2}), do: :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2) + :math.pow(z1 - z2, 2))
  defp distance_from_the_wall({{x1, _, _}, {x2, _, _}}), do: x1 * x2
end
