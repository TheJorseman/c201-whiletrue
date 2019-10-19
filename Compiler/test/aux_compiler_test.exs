defmodule AUXCOMPILERTest do
  use ExUnit.Case
  doctest Compiler

  # Lexer valid tests week 1-----------------------------------

  test "1. Return 2" do
    source_code = """
                  int main() {
                    return 2;
                  }
                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  test "2. Return 0" do
    source_code = """
                  int main() {
                    return 0;
                  }
                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  test "3. Multi digit" do
    source_code = """
                  int main() {
                    return 100;
                  }
                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  test "4. No newlines" do
    source_code = """
                  int main(){return 0;}
                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  test "5. Newlines" do
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
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  test "6. Spaces" do
    source_code = """
                    int   main    (  )  {   return  0 ; }
                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  # Lexer valid tests week 2 --------------------------------------------

  test "7. Bitwise zero" do
    source_code = """
                    int main() {
                      return ~0;
                    }
                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  test "8. Bitwise" do
    source_code = """
                    int main() {
                      return !12;
                    }
                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  test "9. Negation" do
    source_code = """
                    int main() {
                      return -5;
                    }
                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  test "10. Nested operations" do
    source_code = """
                    int main() {
                      return !-3;
                    }
                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  test "11. Nested operations 2" do
    source_code = """
                    int main() {
                      return -~0;
                    }
                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  test "12. Not five" do
    source_code = """
                    int main() {
                      return !5;
                    }
                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  test "13. Not zero" do
    source_code = """
                    int main() {
                      return !0;
                    }
                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

end


