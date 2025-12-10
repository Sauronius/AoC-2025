defmodule DayNineTest do
  use ExUnit.Case

  setup_all do
    file_content = """
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    """

    File.write!("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "part one test" do
    assert DayNine.part_one("testfile.txt") == 50
  end
  test "part one solution" do
    assert DayNine.part_one("../../AoC-2025-inputs/input9.txt") == :solution1
  end

  test "part two test" do
    assert DayNine.part_two("testfile.txt") == 24
  end
  test "part two solution" do
    assert DayNine.part_two("../../AoC-2025-inputs/input9.txt") == :solution2
  end
end
