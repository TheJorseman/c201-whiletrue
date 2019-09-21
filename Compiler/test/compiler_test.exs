defmodule COMPILERTest do
  use ExUnit.Case
  doctest Compiler

  setup_all do
    {:ok, tok_ret2: [{:intKeyword,""},
                  {:identifier, "main"},
                  {:openParen,""},
                  {:closeParen,""},
                  {:openBrace,""},
                  {:returnKeyword,""},
                  {:constant, 2},
                  {:semicolon,""},
                  {:closeBrace,""}
    ]}
  end

  setup_all do
    {:ok, tok_ret0: [{:intKeyword,""},
                  {:identifier, "main"},
                  {:openParen,""},
                  {:closeParen,""},
                  {:openBrace,""},
                  {:returnKeyword,""},
                  {:constant, 0},
                  {:semicolon,""},
                  {:closeBrace,""}
    ]}
  end

  setup_all do
    {:ok, tok_multidig: [{:intKeyword,""},
                  {:identifier, "main"},
                  {:openParen,""},
                  {:closeParen,""},
                  {:openBrace,""},
                  {:returnKeyword,""},
                  {:constant, 100},
                  {:semicolon,""},
                  {:closeBrace,""}
    ]}
  end

  setup_all do
    {:ok, tok_no_semicolon: [{:intKeyword,""},
                  {:identifier, "main"},
                  {:openParen,""},
                  {:closeParen,""},
                  {:openBrace,""},
                  {:returnKeyword,""},
                  {:constant, 0},
                  {:closeBrace,""}
    ]}
  end

  setup_all do
    {:ok, tok_miss_retval: [{:intKeyword,""},
                  {:identifier, "main"},
                  {:openParen,""},
                  {:closeParen,""},
                  {:openBrace,""},
                  {:returnKeyword,""},
                  {:semicolon,""},
                  {:closeBrace,""}
    ]}
  end

  setup_all do
    {:ok, tok_miss_paren: [{:intKeyword,""},
                  {:identifier, "main"},
                  {:openParen,""},
                  {:openBrace,""},
                  {:returnKeyword,""},
                  {:constant, 0},
                  {:semicolon,""},
                  {:closeBrace,""}
    ]}
  end

  setup_all do
    {:ok, tok_no_brace: [{:intKeyword,""},
                  {:identifier, "main"},
                  {:openParen,""},
                  {:closeParen,""},
                  {:openBrace,""},
                  {:returnKeyword,""},
                  {:constant, 0},
                  {:semicolon,""}
    ]}
  end

  # Valid lexer tests
  test "Return 2", state do
    assert Compiler.print_token_list("test/noraS_tests/valid/return_2.c") == state[:tok_ret2]
  end

  test "Return 0", state do
    assert Compiler.print_token_list("test/noraS_tests/valid/return_0.c") == state[:tok_ret0]
  end

  test "Multidigit", state do
    assert Compiler.print_token_list("test/noraS_tests/valid/multi_digit.c") == state[:tok_multidig]
  end

  test "Spaces", state do
    assert Compiler.print_token_list("test/noraS_tests/valid/spaces.c") == state[:tok_ret0]
  end

  test "No new lines", state do
    assert Compiler.print_token_list("test/noraS_tests/valid/no_newlines.c") == state[:tok_ret0]
  end

  test "New lines", state do
    assert Compiler.print_token_list("test/noraS_tests/valid/newlines.c") == state[:tok_ret0]
  end

  # Invalid lexer tests
  test "No semicolon", state do
    assert Compiler.print_token_list("test/noraS_tests/invalid/no_semicolon.c") == state[:tok_no_semicolon]
  end

  test "Missing parenthesis", state do
    assert Compiler.print_token_list("test/noraS_tests/invalid/missing_paren.c") == state[:tok_miss_paren]
  end

  test "No brace", state do
    assert Compiler.print_token_list("test/noraS_tests/invalid/no_brace.c") == state[:tok_no_brace]
  end

  # Valid Compiler test ---------------------------------------------------------------------------

  test "Return 2 - Complete test" do
    assert Compiler.compile_file("test/noraS_tests/valid/return_2.c") == :successfulCompilation
  end

  test "Return 0 - Complete test" do
    assert Compiler.compile_file("test/noraS_tests/valid/return_0.c") == :successfulCompilation
  end

  test "Multidigit - Complete test" do
    assert Compiler.compile_file("test/noraS_tests/valid/multi_digit.c") == :successfulCompilation
  end

  test "Spaces - Complete test" do
    assert Compiler.compile_file("test/noraS_tests/valid/spaces.c") == :successfulCompilation
  end

  test "No new lines - Complete test" do
    assert Compiler.compile_file("test/noraS_tests/valid/no_newlines.c") == :successfulCompilation
  end

  test "New lines - Complete test" do
    assert Compiler.compile_file("test/noraS_tests/valid/newlines.c") == :successfulCompilation
  end


end
