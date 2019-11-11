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

  test "22. Sub neg", state do
    source_code = """
                    int main() {
                      return 2- -1;
                    }
                  """
    sub1 = List.update_at(state[:bin_op_1], 6, fn _ -> {:constant, 2, 2} end)
    sub2 = List.update_at(sub1, 7, fn _ -> {:negation_minus, "-", 2} end)
    sub3 = List.update_at(sub2, 8, fn _ -> {:constant, 1, 2} end)
    sub4 = List.insert_at(sub3, 8, {:negation_minus, "-", 2})
    assert Lexer.lexer(source_code) == sub4
  end

  test "23. Sub", state do
    source_code = """
                    int main() {
                      return 1 - 2;
                    }
                  """
    sub = List.update_at(state[:bin_op_1], 7, fn _ -> {:negation_minus, "-", 2} end)
    assert Lexer.lexer(source_code) == sub
  end

  test "24. Un op add", state do
    source_code = """
                    int main() {
                      return ~2 + 3;
                    }
                  """
    un_op1 = List.update_at(state[:bin_op_1], 6, fn _ -> {:constant, 2, 2} end)
    un_op2 = List.update_at(un_op1, 8, fn _ -> {:constant, 3, 2} end)
    un_op3 = List.insert_at(un_op2, 6, {:bitwiseN, "~", 2})
    assert Lexer.lexer(source_code) == un_op3
  end

  test "25. Un op parens", state do
    source_code = """
                    int main() {
                      return ~(1 + 1);
                    }
                  """
    un_op1 = List.insert_at(state[:bin_op_1], 6, {:bitwiseN, "~", 2})
    un_op2 = List.update_at(un_op1, 7, fn _ -> {:constant, 1, 2} end)
    un_op3 = List.update_at(un_op2, 9, fn _ -> {:constant, 1, 2} end)
    un_op4 = List.insert_at(un_op3, 7, {:openParen, "", 2})
    un_op5 = List.insert_at(un_op4, 11, {:closeParen, "", 2})
    assert Lexer.lexer(source_code) == un_op5
  end









  # Valid tests week 4  --------------------------------------------

  test "26. And false", state do
    source_code = """
                    int main() {
                      return 1 && 0;
                    }
                  """
    and1 = List.update_at(state[:bin_op_1], 7, fn _ -> {:andT, "&&", 2} end)
    and2 = List.update_at(and1, 8, fn _ -> {:constant, 0, 2} end)
    assert Lexer.lexer(source_code) == and2
  end

  test "27. And true", state do
    source_code = """
                    int main() {
                      return 1 && -1;
                    }
                  """
    and1 = List.update_at(state[:bin_op_1], 7, fn _ -> {:andT, "&&", 2} end)
    and2 = List.update_at(and1, 8, fn _ -> {:constant, 1, 2} end)
    and3 = List.insert_at(and2, 8, {:negation_minus, "-", 2})
    assert Lexer.lexer(source_code) == and3
  end

  test "28. Eq false", state do
    source_code = """
                    int main() {
                      return 1 == 2;
                    }
                  """
    eq1 = List.update_at(state[:bin_op_1], 7, fn _ -> {:equal, "==", 2} end)
    assert Lexer.lexer(source_code) == eq1
  end

  test "29. Eq true", state do
    source_code = """
                    int main() {
                      return 1 == 1;
                    }
                  """
    eq1 = List.update_at(state[:bin_op_1], 7, fn _ -> {:equal, "==", 2} end)
    eq2 = List.update_at(eq1, 8, fn _ -> {:constant, 1, 2} end)
    assert Lexer.lexer(source_code) == eq2
  end

  test "30. Ge false", state do
    source_code = """
                    int main() {
                      return 1 >= 2;
                    }
                  """
    ge1 = List.update_at(state[:bin_op_1], 7, fn _ -> {:greaterThanEq, "!=", 2} end)
    assert Lexer.lexer(source_code) == ge1
  end

  test "31. Ge true", state do
    source_code = """
                    int main() {
                      return 1 >= 1;
                    }
                  """
    ge1 = List.update_at(state[:bin_op_1], 7, fn _ -> {:greaterThanEq, "!=", 2} end)
    ge2 = List.update_at(ge1, 8, fn _ -> {:constant, 1, 2} end)
    assert Lexer.lexer(source_code) == ge2
  end

  test "32. Gt false", state do
    source_code = """
                    int main() {
                      return 1 > 2;
                    }
                  """
    gt1 = List.update_at(state[:bin_op_1], 7, fn _ -> {:greaterThan, "!=", 2} end)
    assert Lexer.lexer(source_code) == gt1
  end

  test "33. Gt true", state do
    source_code = """
                    int main() {
                      return 1 > 0;
                    }
                  """
    gt1 = List.update_at(state[:bin_op_1], 7, fn _ -> {:greaterThan, "!=", 2} end)
    gt2 = List.update_at(gt1, 8, fn _ -> {:constant, 0, 2} end)
    assert Lexer.lexer(source_code) == gt2
  end

  test "34. Le false", state do
    source_code = """
                    int main() {
                      return 1 <= -1;
                    }
                  """
    le1 = List.update_at(state[:bin_op_1], 7, fn _ -> {:lessThanEq, "!=", 2} end)
    le2 = List.update_at(le1, 8, fn _ -> {:constant, 1, 2} end)
    le3 = List.insert_at(le2, 8, {:negation_minus, "-", 2})
    assert Lexer.lexer(source_code) == le3
  end

  # test "35. Le true" do
  #   source_code = """
  #                   int main() {
  #                     return 0 <= 2;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "36. Lt false" do
  #   source_code = """
  #                   int main() {
  #                     return 2 < 1;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "37. Lt true" do
  #   source_code = """
  #                   int main() {
  #                     return 1 < 2;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "38. Ne false" do
  #   source_code = """
  #                   int main() {
  #                     return 0 != 0;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "39. Ne true" do
  #   source_code = """
  #                   int main() {
  #                     return -1 != -2;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "40. Or false" do
  #   source_code = """
  #                   int main() {
  #                     return 0 || 0;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "41. Or true" do
  #   source_code = """
  #                   int main() {
  #                     return 1 || 0;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "42. Precedence" do
  #   source_code = """
  #                   int main() {
  #                     return 1 || 0 && 2;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "43. Precedence 2" do
  #   source_code = """
  #                   int main() {
  #                     return (1 || 0) && 0;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "44. Precedence 3" do
  #   source_code = """
  #                   int main() {
  #                     return 2 == 2 > 0;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "45. Precedence 4" do
  #   source_code = """
  #                   int main() {
  #                     return 2 == 2 || 0;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "46. Skip on failure multi short circuit" do
  #   source_code = """
  #                   int main() {
  #                     int a = 0;
  #                     a || (a = 3) || (a = 4);
  #                     return a;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "47. Skip on failure short circuit and" do
  #   source_code = """
  #                   int main() {
  #                     int a = 0;
  #                     int b = 0;
  #                     a && (b = 5);
  #                     return b;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end

  # test "48. Skip on failure short circuit or" do
  #   source_code = """
  #                   int main() {
  #                     int a = 1;
  #                     int b = 0;
  #                     a || (b = 5);
  #                     return b;
  #                   }
  #                 """
  #   assert Lexer.lexer(source_code) ==
  # end


end


