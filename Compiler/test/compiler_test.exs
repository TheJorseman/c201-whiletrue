defmodule COMPILERTest do
  use ExUnit.Case
  doctest COMPILER

  test "greets the world" do
    assert COMPILER.hello() == :world
  end
end
