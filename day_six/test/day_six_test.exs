defmodule DaySixTest do
  use ExUnit.Case

  setup_all do
    file_content = """
    123 328  51 64
     45 64  387 23
      6 98  215 314
    *   +   *   +
    """

    File.write!("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "part one test" do
    assert DaySix.part_one("testfile.txt") == 4277556
  end
  test "part one solution" do
    assert DaySix.part_one("../../AoC-2025-inputs/input6.txt") == :solution1
  end

  test "part two test" do
    assert DaySix.part_two("testfile.txt") == 3263827
  end
  test "part two solution" do
    assert DaySix.part_two("../../AoC-2025-inputs/input6.txt") == :solution2
  end
end
