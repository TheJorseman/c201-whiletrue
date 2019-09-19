defmodule COMPILERTest do
  use ExUnit.Case
  doctest COMPILER

  setup_all do
    {:ok, tokens: [:intKeyword,
                  {:identifier, "int"},
                  :openParen,
                  :closeParen,
                  :openBrace,
                  :returnKeyword,
                  {:constant, 2},
                  :semicolon,
                  :closeBrace
    ]}
  end

  test "Return 2", state do
    assert Lexer.lexer([test/nosaS_tests/valid/return_2.c]) == state[:tokens]
  end
end
