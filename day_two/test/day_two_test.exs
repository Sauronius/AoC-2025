defmodule DayTwoTest do
  use ExUnit.Case

  setup_all do
    file_content = """
    11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    """

    File.write!("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "part one test" do
    assert DayTwo.part_one("testfile.txt") == 1227775554
  end
  test "part one solution" do
    assert DayTwo.part_one("../../AoC-2025-inputs/input2.txt") == :solution1
  end

  test "part two test" do
    assert DayTwo.part_two("testfile.txt") == 4174379265
  end
  test "part two solution" do
    assert DayTwo.part_two("../../AoC-2025-inputs/input2.txt") == :solution2
  end
end
