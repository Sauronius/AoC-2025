defmodule DayFourTest do
  use ExUnit.Case

  setup_all do
    file_content = """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """

    File.write!("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "part one test" do
    assert DayFour.part_one("testfile.txt") == 13
  end
  test "part one solution" do
    assert DayFour.part_one("../../AoC-2025-inputs/input4.txt") == :solution1
  end

  test "part two test" do
    assert DayFour.part_two("testfile.txt") == 43
  end
  test "part two solution" do
    assert DayFour.part_two("../../AoC-2025-inputs/input4.txt") == :solution2
  end
end
