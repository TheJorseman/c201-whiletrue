defmodule COMPILERTest do
  use ExUnit.Case
  doctest Compiler

  setup_all do
    {:ok,
    tok_ret2: [{:intKeyword, "", 1},
                {:identifier, "main", 1},
                {:openParen, "", 1},
                {:closeParen, "", 1},
                {:openBrace, "", 1},
                {:returnKeyword, "", 2},
                {:constant, 2, 2},
                {:semicolon, "", 2},
                {:closeBrace, "", 3}
    ],

    tok_ret0: [{:intKeyword, "", 1},
                {:identifier, "main", 1},
                {:openParen, "", 1},
                {:closeParen, "", 1},
                {:openBrace, "", 1},
                {:returnKeyword, "", 2},
                {:constant, 0, 2},
                {:semicolon, "", 2},
                {:closeBrace, "", 3}
    ],

    multi_digit: [{:intKeyword, "", 1},
                {:identifier, "main", 1},
                {:openParen, "", 1},
                {:closeParen, "", 1},
                {:openBrace, "", 1},
                {:returnKeyword, "", 2},
                {:constant, 100, 2},
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
    ]
    }

  end

  # Valid lexer tests -----------------------------------

  test "1. Return 2", state do
    source_code = """
                  int main() {
                    return 2;
                  }
                  """
    assert Lexer.lexer(source_code) == state[:tok_ret2]
  end

  test "2. Return 0", state do
    source_code = """
                  int main() {
                    return 0;
                  }
                  """
    assert Lexer.lexer(source_code) == state[:tok_ret0]
  end

  test "3. Multi digit", state do
    source_code = """
                  int main() {
                    return 100;
                  }
                  """
    assert Lexer.lexer(source_code) == state[:multi_digit]
  end

  test "4. No newlines", state do
    source_code = """
                  int main(){return 0;}
                  """
    assert Lexer.lexer(source_code) == state[:no_newlines]
  end

  # test "5. Newlines", state do
  #   source_code = """

  #                 int
  #                 main
  #                 (
  #                 )
  #                 {
  #                 return
  #                 0
  #                 ;
  #                 }
  #                 """
  #   assert Lexer.lexer(source_code) == state[:newlines]
  # end

  test "6. Spaces", state do
    source_code = """
                    int   main    (  )  {   return  0 ; }
                  """
    assert Lexer.lexer(source_code) == state[:no_newlines]
  end



end
