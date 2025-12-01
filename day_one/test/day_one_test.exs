defmodule DayOneTest do
  use ExUnit.Case

  setup_all do
    file_content = """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """

    File.write!("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "part one test" do
    assert DayOne.part_one("testfile.txt") == 3
  end
  test "part one solution" do
    assert DayOne.part_one("../../AoC-2025-inputs/input1.txt") == :solution1
  end

  test "part two test" do
    assert DayOne.part_two("testfile.txt") == 6
  end
  test "part two solution" do
    assert DayOne.part_two("../../AoC-2025-inputs/input1.txt") == :solution2
  end
end
