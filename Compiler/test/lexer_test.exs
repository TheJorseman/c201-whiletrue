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
    ],

    # week 3

    bin_op_1: [{:intKeyword, "int", 1},#0
                {:identifier, "main", 1},#1
                {:openParen, "", 1},#2
                {:closeParen, "", 1},#3
                {:openBrace, "", 1},#4
                {:returnKeyword, "", 2},#5
                {:constant, 1, 2},#6
                {:addition, "+", 2},#7
                {:constant, 2, 2},#8
                {:semicolon, "", 2},#9
                {:closeBrace, "", 3}#10
    ],

    bin_op_2: [{:intKeyword, "int", 1},#0
                {:identifier, "main", 1},#1
                {:openParen, "", 1},#2
                {:closeParen, "", 1},#3
                {:openBrace, "", 1},#4
                {:returnKeyword, "", 2},#5
                {:constant, 1, 2},#6
                {:negation_minus, "-", 2},#7
                {:constant, 2, 2},#8
                {:negation_minus, "-", 2},#9
                {:constant, 3, 2},#10
                {:semicolon, "", 2},#11
                {:closeBrace, "", 3}#12
    ],

    bin_op_3: [{:intKeyword, "int", 1},
                {:identifier, "main", 1},#1
                {:openParen, "", 1},
                {:closeParen, "", 1},#3
                {:openBrace, "", 1},
                {:returnKeyword, "", 2},#5
                {:constant, 2, 2},
                {:addition, "+", 2},#7
                {:constant, 3, 2},
                {:multiplication, "*", 2},#9
                {:constant, 4, 2},
                {:semicolon, "", 2},#11
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

  # Lexer valid tests week 3 --------------------------------------------

  test "14. Add", state do
    source_code = """
                    int main() {
                      return 1 + 2;
                    }
                  """
    assert Lexer.lexer(source_code) == state[:bin_op_1]
  end

  test "15. Associativity", state do
    source_code = """
                    int main() {
                      return 1 - 2 - 3;
                    }
                  """
    assert Lexer.lexer(source_code) == state[:bin_op_2]
  end

  test "16. Associativity 2", state do
    source_code = """
                    int main() {
                      return 6 / 3 / 2;
                    }
                  """
    assoc1 = List.update_at(state[:bin_op_2], 6, fn _ -> {:constant, 6, 2} end)
    assoc2 = List.update_at(assoc1, 7, fn _ -> {:division, "/", 2} end)
    assoc3 = List.update_at(assoc2, 8, fn _ -> {:constant, 3, 2} end)
    assoc4 = List.update_at(assoc3, 9, fn _ -> {:division, "/", 2} end)
    assoc5 = List.update_at(assoc4, 10, fn _ -> {:constant, 2, 2} end)
    assert Lexer.lexer(source_code) == assoc5
  end

  test "17. Div neg", state do
    source_code = """
                    int main() {
                      return (-12) / 5;
                    }
                  """
    div1 = List.update_at(state[:bin_op_2], 6, fn _ -> {:openParen, "", 2} end)
    div2 = List.update_at(div1, 8, fn _ -> {:constant, 12, 2} end)
    div3 = List.update_at(div2, 9, fn _ -> {:closeParen, "", 2} end)
    div4 = List.update_at(div3, 10, fn _ -> {:division, "/", 2} end)
    div5 = List.insert_at(div4, 11, {:constant, 5, 2})
    assert Lexer.lexer(source_code) == div5
  end

  test "18. Div", state do
    source_code = """
                    int main() {
                      return 4 / 2;
                    }
                  """
    div1 = List.update_at(state[:bin_op_1], 6, fn _ -> {:constant, 4, 2} end)
    div2 = List.update_at(div1, 7, fn _ -> {:division, "/", 2} end)
    div3 = List.update_at(div2, 8, fn _ -> {:constant, 2, 2} end)
    assert Lexer.lexer(source_code) == div3
  end

  test "19. Mult", state do
    source_code = """
                    int main() {
                      return 2 * 3;
                    }
                  """
    mul1 = List.update_at(state[:bin_op_1], 6, fn _ -> {:constant, 2, 2} end)
    mul2 = List.update_at(mul1, 7, fn _ -> {:multiplication, "*", 2} end)
    mul3 = List.update_at(mul2, 8, fn _ -> {:constant, 3, 2} end)
    assert Lexer.lexer(source_code) == mul3
  end

  test "20. Parens", state do
    source_code = """
                    int main() {
                      return 2 * (3 + 4);
                    }
                  """
    par1 = List.update_at(state[:bin_op_3], 7, fn _ -> {:multiplication, "*", 2} end)
    par2 = List.update_at(par1, 9, fn _ -> {:addition, "+", 2} end)
    par3 = List.insert_at(par2, 8, {:openParen, "", 2})
    par4 = List.insert_at(par3, 12, {:closeParen, "", 2})
    assert Lexer.lexer(source_code) == par4
  end

  test "21. Precedence", state do
    source_code = """
                    int main() {
                      return 2 + 3 * 4;
                    }
                  """
    assert Lexer.lexer(source_code) == state[:bin_op_3]
  end

  # test "22. Sub neg" do
  #   source_code = """
  #                   int main() {
  #                     return 2- -1;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) == :successfulComp
  # end

  # test "23. Sub" do
  #   source_code = """
  #                   int main() {
  #                     return 1 - 2;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) == :successfulComp
  # end

  # test "24. Un op add" do
  #   source_code = """
  #                   int main() {
  #                     return ~2 + 3;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) == :successfulComp
  # end

  # test "25. Un op parens" do
  #   source_code = """
  #                   int main() {
  #                     return ~(1 + 1);
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) == :successfulComp
  # end



end


