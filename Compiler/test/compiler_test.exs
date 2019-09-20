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

  setup_all do
    {:ok, tok_no semicolon: [:intKeyword,
                  {:identifier, "main"},
                  :openParen,
                  :closeParen,
                  :openBrace,
                  :returnKeyword,
                  {:constant, 0},
                  :closeBrace
    ]}
  end

  setup_all do
    {:ok, tok_miss_retval: [:intKeyword,
                  {:identifier, "main"},
                  :openParen,
                  :closeParen,
                  :openBrace,
                  :returnKeyword,
                  :semicolon,
                  :closeBrace
    ]}
  end

  setup_all do
    {:ok, tok_miss_paren: [:intKeyword,
                  {:identifier, "main"},
                  :openParen,
                  :openBrace,
                  :returnKeyword,
                  {:constant, 0},
                  :semicolon,
                  :closeBrace
    ]}
  end

  setup_all do
    {:ok, tok_no_brace: [:intKeyword,
                  {:identifier, "main"},
                  :openParen,
                  :closeParen,
                  :openBrace,
                  :returnKeyword,
                  {:constant, 0},
                  :semicolon
    ]}
  end

  # Valid tests
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

  # Invalid tests
  test "No semicolon", state do
    assert Lexer.lexer([test/noraS_tests/invalid/no_semicolon.c]) == state[:tok_no_semicolon]
  end

  #test "Wrong case", state do
  # assert Lexer.lexer([test/noraS_tests/invalid/wrong_case.c]) == state[:tok_wrong_case]
  #end

  test "Missing return value", state do
    assert Lexer.lexer([test/noraS_tests/invalid/missing_retval.c]) == state[:tok_miss_retval]
  end

  test "Missing parenthesis", state do
    assert Lexer.lexer([test/noraS_tests/invalid/missing_paren.c]) == state[:tok_miss_paren]
  end

  test "No brace", state do
    assert Lexer.lexer([test/noraS_tests/invalid/no_brace.c]) == state[:tok_no_brace]
  end

  #test "No space", state do
  #  assert Lexer.lexer([test/noraS_tests/invalid/no_space.c]) == state[:tok_no_space]
  #end

end
