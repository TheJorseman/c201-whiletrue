defmodule LEXERTest do
  use ExUnit.Case
  doctest Compiler

  setup_all do
    {:ok,
    tok_ret_2: [{:intKeyword, "", 1},
                {:identifier, "main", 1},
                {:openParen, "", 1},
                {:closeParen, "", 1},
                {:openBrace, "", 1},
                {:returnKeyword, "", 2},
                {:constant, 2, 2},
                {:semicolon, "", 2},
                {:closeBrace, "", 3}
    ],

    no_newlines: [{:intKeyword, "", 1},
                {:identifier, "main", 1},
                {:openParen, "", 1},
                {:closeParen, "", 1},
                {:openBrace, "", 1},
                {:returnKeyword, "", 1},
                {:constant, 0, 1},
                {:semicolon, "", 1},
                {:closeBrace, "", 1}
    ],
    newlines: [{:intKeyword, "", 2},
                {:identifier, "main", 3},
                {:openParen, "", 4},
                {:closeParen, "", 5},
                {:openBrace, "", 6},
                {:returnKeyword, "", 7},
                {:constant, 0, 8},
                {:semicolon, "", 9},
                {:closeBrace, "", 10}
    ],
    # week 2

    bitwise_0: [{:intKeyword, "", 1},
      {:identifier, "main", 1},
      {:openParen, "", 1},
      {:closeParen, "", 1},
      {:openBrace, "", 1},
      {:returnKeyword, "", 2},
      {:bitwiseN, "", 2},
      {:constant, 0, 2},
      {:semicolon, "", 2},
      {:closeBrace, "", 3}]

    }

  end

  # Valid lexer tests week 1-----------------------------------

  test "1. Return 2", state do
    source_code = """
                  int main() {
                    return 2;
                  }
                  """
    assert Lexer.lexer(source_code) == state[:tok_ret_2]
  end

  test "2. Return 0", state do
    source_code = """
                  int main() {
                    return 0;
                  }
                  """
    tok_ret_0 = List.update_at(state[:tok_ret_2], 6, fn _ -> {:constant, 0, 2} end)
    assert Lexer.lexer(source_code) == tok_ret_0
  end

  test "3. Multi digit", state do
    source_code = """
                  int main() {
                    return 100;
                  }
                  """
    tok_ret_100 = List.update_at(state[:tok_ret_2], 6, fn _ -> {:constant, 100, 2} end)
    assert Lexer.lexer(source_code) == tok_ret_100
  end

  test "4. No newlines", state do
    source_code = """
                  int main(){return 0;}
                  """
    assert Lexer.lexer(source_code) == state[:no_newlines]
  end

  test "5. Newlines", state do
    source_code = """

                  int
                  main
                  (
                  )
                  {
                  return
                  0
                  ;
                  }
                  """
    assert Lexer.lexer(source_code) == state[:newlines]
  end

  test "6. Spaces", state do
    source_code = """
                    int   main    (  )  {   return  0 ; }
                  """
    assert Lexer.lexer(source_code) == state[:no_newlines]
  end

  #valid test week 2 ---------------------------------------------

  # bitwise_zero ok
  # bitwise ok
  # neg ok
  # nested_ops ok
  # nested_ops_2 ok
  # not_five ok
  # not_zero ok

  test "7. Bitwise zero", state do
    source_code = """
                    int main() {
                      return ~0;
                    }
                  """
    assert Lexer.lexer(source_code) == state[:bitwise_0]
  end


end


