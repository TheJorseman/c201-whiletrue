defmodule INVALIDCOMPILERTest do
  use ExUnit.Case
  doctest Compiler

  # Invalid tests - week 1

  test "1. Missing parenthesis" do
    source_code = """
                    int main( {
                      return 0;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error: ) keyword expected at line 1"}
  end

  test "2. Missing return value" do
    source_code = """
                    int main() {
                      return;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Unexpected returnKeyword Token at line 2"}
  end

  test "3. No closing brace" do
    source_code = """
                    int main() {
                      return 0;

                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error: } keyword expected at line 2"}
  end

  test "4. No semicolon" do
    source_code = """
                    int main() {
                      return 0
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error Semicolon keyword expected at line 2"}
  end

  test "5. No space" do
    source_code = """
                    int main() {
                      return0;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Unexpected returnKeyword Token at line 2"}
  end

  test "6. Wrong case" do
    source_code = """
                    int main() {
                      RETURN 0;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error return keyword expected at line 2"}
  end

  # Invalid tests - week 2

  test "7. Missing constant" do
    source_code = """
                    int main() {
                      return !;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error before ';' Unary operator or constant keyword expected at line 2"}
  end

  test "8. Missing semicolon" do
    source_code = """
                    int main() {
                      return !5
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error Semicolon keyword expected at line 2"}
  end

  test "9. Nested operators, missing constant" do
    source_code = """
                    int main() {
                      return !~;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error before ';' Unary operator or constant keyword expected at line 2"}
  end

  test "10. Wrong order" do
    source_code = """
                    int main() {
                      return 4-;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error before ';' Unary operator or constant keyword expected at line 2"}
  end

  # Invalid tests - week 3

  test "11. Malformed paren" do
    source_code = """
                    int main() {
                      return 2 (- 3);
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error Semicolon keyword expected at line 2"}
  end

  test "12. Missing first op" do
    source_code = """
                    int main() {
                      return /3;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error before '/' Unary operator or constant keyword expected at line 2"}
  end

  test "13. Missing second op" do
    source_code = """
                    int main() {
                      return 1 + ;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error before ';' Unary operator or constant keyword expected at line 2"}
  end

  test "14. No semicolon" do
    source_code = """
                    int main() {
                      return 2*2
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error Semicolon keyword expected at line 2"}
  end

  # Invalid tests - week 4

  test "15. Missing first operator" do
    source_code = """
                    int main() {
                      return <= 2;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error before '<=' Unary operator or constant keyword expected at line 2"}
  end

  test "16. Missing mid operator" do
    source_code = """
                    int main() {
                      return 1 < > 3;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error before '>' Unary operator or constant keyword expected at line 2"}
  end

  test "17. Missing second operator" do
    source_code = """
                    int main() {
                      return 2 &&
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error before '}' Unary operator or constant keyword expected at line 3"}
  end

  test "18. Missing semicolon" do
    source_code = """
                    int main() {
                      return 1 || 2
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error Semicolon keyword expected at line 2"}
  end

end


