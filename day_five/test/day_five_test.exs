defmodule DayFiveTest do
  use ExUnit.Case

  setup_all do
    file_content = """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """

    File.write!("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "part one test" do
    assert DayFive.part_one("testfile.txt") == 3
  end
  test "part one solution" do
    assert DayFive.part_one("../../AoC-2025-inputs/input5.txt") == :solution1
  end

  test "part two test" do
    assert DayFive.part_two("testfile.txt") == 14
  end
  test "part two solution" do
    assert DayFive.part_two("../../AoC-2025-inputs/input5.txt") == :solution2
  end
end
