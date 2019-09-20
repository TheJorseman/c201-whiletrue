defmodule COMPILERTest do
  use ExUnit.Case
  doctest COMPILER

  setup_all do
    {:ok, tok_ret2: [:intKeyword,
                  {:identifier, "main"},
                  :openParen,
                  :closeParen,
                  :openBrace,
                  :returnKeyword,
                  {:constant, 2},
                  :semicolon,
                  :closeBrace
    ]}
  end

  setup_all do
    {:ok, tok_ret0: [:intKeyword,
                  {:identifier, "main"},
                  :openParen,
                  :closeParen,
                  :openBrace,
                  :returnKeyword,
                  {:constant, 0},
                  :semicolon,
                  :closeBrace
    ]}
  end

  setup_all do
    {:ok, tok_multidig: [:intKeyword,
                  {:identifier, "main"},
                  :openParen,
                  :closeParen,
                  :openBrace,
                  :returnKeyword,
                  {:constant, 100},
                  :semicolon,
                  :closeBrace
    ]}
  end

  test "Return 2", state do
    assert Lexer.lexer([test/noraS_tests/valid/return_2.c]) == state[:tok_ret2]
  end

  test "Return 0", state do
    assert Lexer.lexer([test/noraS_tests/valid/return_0.c]) == state[:tok_ret0]
  end

  test "Multidigit", state do
    assert Lexer.lexer([test/noraS_tests/valid/multi_digit.c]) == state[:tok_multidig]
  end

  test "Spaces", state do
    assert Lexer.lexer([test/noraS_tests/valid/spaces.c]) == state[:tok_ret0]
  end

  test "No new lines", state do
    assert Lexer.lexer([test/noraS_tests/valid/no_newlines.c]) == state[:tok_ret0]
  end

  test "New lines", state do
    assert Lexer.lexer([test/noraS_tests/valid/newlines.c]) == state[:tok_ret0]
  end
end
