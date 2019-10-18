defmodule COMPILERTest do
  use ExUnit.Case
  doctest Compiler

  # Invalid tests - week 1

  test "7. Missing parenthesis" do
    source_code = """
                    int main( {
                      return 0;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error: ) keyword expected at line 1"}
  end

  test "8. Missing return value" do
    source_code = """
                    int main() {
                      return;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Unexpected returnKeyword Token at line 2"}
  end

  test "9. No closing brace" do
    source_code = """
                    int main() {
                      return 0;

                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error: } keyword expected at line 2"}
  end

  test "10. No semicolon" do
    source_code = """
                    int main() {
                      return 0
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error Semicolon keyword expected at line 3"}
  end

  test "11. No space" do
    source_code = """
                    int main() {
                      return0;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Unexpected returnKeyword Token at line 2"}
  end

  test "12. Wrong case" do
    source_code = """
                    int main() {
                      RETURN 0;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Unexpected Token RETURN 0; at line 2"}
  end

  # Invalid tests - week 2

  test "20. Missing constant" do
    source_code = """
                    int main() {
                      return !;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error Unary operator or constant keyword expected at line 2"}
  end

  # debería marcar error en la línea 2
  test "21. Missing semicolon" do
    source_code = """
                    int main() {
                      return !5
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error Semicolon keyword expected at line 3"}
  end

  test "22. Nested operators, missing constant" do
    source_code = """
                    int main() {
                      return !~;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error Unary operator or constant keyword expected at line 2"}
  end

  test "23. Wrong order" do
    source_code = """
                    int main() {
                      return 4-;
                    }
                  """
    assert Compiler.compiler_test(source_code) == {:error,"Syntax Error Semicolon keyword expected at line 2"}
  end

end


