defmodule LEXERTest do
  use ExUnit.Case
  doctest Compiler

  setup_all do
    {:ok,

    # week 1

    tok_ret_2: [{:intKeyword, "int", 1},
                {:identifier, "main", 1},
                {:openParen, "", 1},
                {:closeParen, "", 1},
                {:openBrace, "", 1},
                {:returnKeyword, "", 2},
                {:constant, 2, 2},
                {:semicolon, "", 2},
                {:closeBrace, "", 3}
    ],

    no_newlines: [{:intKeyword, "int", 1},
                {:identifier, "main", 1},
                {:openParen, "", 1},
                {:closeParen, "", 1},
                {:openBrace, "", 1},
                {:returnKeyword, "", 1},
                {:constant, 0, 1},
                {:semicolon, "", 1},
                {:closeBrace, "", 1}
    ],

    newlines: [{:intKeyword, "int", 2},
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

    bitwise_0: [{:intKeyword, "int", 1},
                {:identifier, "main", 1},
                {:openParen, "", 1},
                {:closeParen, "", 1},
                {:openBrace, "", 1},
                {:returnKeyword, "", 2},
                {:bitwiseN, "~", 2},
                {:constant, 0, 2},
                {:semicolon, "", 2},
                {:closeBrace, "", 3}
    ]

    }

  end

  # Lexer valid tests week 1-----------------------------------

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

  # Lexer valid tests week 2 --------------------------------------------

  test "7. Bitwise zero", state do
    source_code = """
                    int main() {
                      return ~0;
                    }
                  """
    assert Lexer.lexer(source_code) == state[:bitwise_0]
  end

  test "8. Bitwise", state do
    source_code = """
                    int main() {
                      return !12;
                    }
                  """
    bitwise = List.update_at(state[:bitwise_0], 6, fn _ -> {:logicalN, "!", 2} end)
    bitwise_12 = List.update_at(bitwise, 7, fn _ -> {:constant, 12, 2} end)
    assert Lexer.lexer(source_code) == bitwise_12
  end

  test "9. Negation", state do
    source_code = """
                    int main() {
                      return -5;
                    }
                  """
    neg = List.update_at(state[:bitwise_0], 6, fn _ -> {:negation_minus, "-", 2} end)
    neg_5 = List.update_at(neg, 7, fn _ -> {:constant, 5, 2} end)
    assert Lexer.lexer(source_code) == neg_5
  end

  test "10. Nested operations", state do
    source_code = """
                    int main() {
                      return !-3;
                    }
                  """
    log = List.update_at(state[:bitwise_0], 6, fn _ -> {:logicalN, "!", 2} end)
    neg = List.insert_at(log, 7, {:negation_minus, "-", 2})
    nested_3 = List.update_at(neg, 8, fn _ -> {:constant, 3, 2} end)
    assert Lexer.lexer(source_code) == nested_3
  end

  test "11. Nested operations 2", state do
    source_code = """
                    int main() {
                      return -~0;
                    }
                  """
    nested = List.insert_at(state[:bitwise_0], 6, {:negation_minus, "-", 2})
    assert Lexer.lexer(source_code) == nested
  end

  test "12. Not five", state do
    source_code = """
                    int main() {
                      return !5;
                    }
                  """
    neg = List.update_at(state[:bitwise_0], 6, fn _ -> {:logicalN, "!", 2} end)
    not_5 = List.update_at(neg, 7, fn _ -> {:constant, 5, 2} end)
    assert Lexer.lexer(source_code) == not_5
  end

  test "13. Not zero", state do
    source_code = """
                    int main() {
                      return !0;
                    }
                  """
    not_5 = List.update_at(state[:bitwise_0], 6, fn _ -> {:logicalN, "!", 2} end)
    assert Lexer.lexer(source_code) == not_5
  end

end


