defmodule COMPILERTest do
  use ExUnit.Case
  doctest Compiler

  setup_all do
    {:ok, tok_ret2: [{:intKeyword, "", 1},
                  {:identifier, "main", 1},
                  {:openParen, "", 1},
                  {:closeParen, "", 1},
                  {:openBrace, "", 1},
                  {:returnKeyword, "", 2},
                  {:constant, 2, 2},
                  {:semicolon, "", 2},
                  {:closeBrace, "", 3}
    ]}
  end

  # Valid lexer tests
  test "Return 2", state do
    assert Compiler.print_token_list("test/noraS_tests/valid/return_2.c") == state[:tok_ret2]
  end

end
