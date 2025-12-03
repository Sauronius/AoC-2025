defmodule DayThreeTest do
  use ExUnit.Case

  setup_all do
    file_content = """
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    """

    File.write!("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "part one test" do
    assert DayThree.part_one("testfile.txt") == 357
  end
  test "part one solution" do
    assert DayThree.part_one("../../AoC-2025-inputs/input3.txt") == :solution1
  end

  test "part two test" do
    assert DayThree.part_two("testfile.txt") == 3121910778619
  end
  test "part two solution" do
    assert DayThree.part_two("../../AoC-2025-inputs/input3.txt") == :solution2
  end
end
