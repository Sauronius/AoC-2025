defmodule DayEightTest do
  use ExUnit.Case

  setup_all do
    file_content = """
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
    """

    File.write!("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "part one test" do
    assert DayEight.part_one("testfile.txt", 10) == 40
  end
  test "part one solution" do
    assert DayEight.part_one("../../AoC-2025-inputs/input8.txt") == :solution1
  end

  test "part two test" do
    assert DayEight.part_two("testfile.txt") == 25272
  end
  test "part two solution" do
    assert DayEight.part_two("../../AoC-2025-inputs/input8.txt") == :solution2
  end
end
