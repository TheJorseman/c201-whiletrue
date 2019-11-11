defmodule CODEGENTest do
  use ExUnit.Case
  doctest Compiler

  # Valid tests week 1-----------------------------------

  test "1. Return 2" do
    source_code = """

                      .globl main
                      main:
                          mov $0, %rax
                      ret


                  """
    assert Compiler.compiler_test(source_code) == :successfulComp
  end

  # test "2. Return 0" do
  #   source_code = """
  #                 int main() {
  #                   return 0;
  #                 }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "3. Multi digit" do
  #   source_code = """
  #                 int main() {
  #                   return 100;
  #                 }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "4. No newlines" do
  #   source_code = """
  #                 int main(){return 0;}
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "5. Newlines" do
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
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "6. Spaces" do
  #   source_code = """
  #                   int   main    (  )  {   return  0 ; }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # # Valid tests week 2 --------------------------------------------

  # test "7. Bitwise zero" do
  #   source_code = """
  #                   int main() {
  #                     return ~0;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "8. Bitwise" do
  #   source_code = """
  #                   int main() {
  #                     return !12;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "9. Negation" do
  #   source_code = """
  #                   int main() {
  #                     return -5;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "10. Nested operations" do
  #   source_code = """
  #                   int main() {
  #                     return !-3;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "11. Nested operations 2" do
  #   source_code = """
  #                   int main() {
  #                     return -~0;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "12. Not five" do
  #   source_code = """
  #                   int main() {
  #                     return !5;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "13. Not zero" do
  #   source_code = """
  #                   int main() {
  #                     return !0;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # # Valid tests week 3-----------------------------------

  # test "14. Add" do
  #   source_code = """
  #                   int main() {
  #                     return 1 + 2;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "15. Associativity" do
  #   source_code = """
  #                   int main() {
  #                     return 1 - 2 - 3;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "16. Associativity 2" do
  #   source_code = """
  #                   int main() {
  #                     return 6 / 3 / 2;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "17. Div neg" do
  #   source_code = """
  #                   int main() {
  #                     return (-12) / 5;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "18. Div" do
  #   source_code = """
  #                   int main() {
  #                     return 4 / 2;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "19. Mult" do
  #   source_code = """
  #                   int main() {
  #                     return 2 * 3;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "20. Parens" do
  #   source_code = """
  #                   int main() {
  #                     return 2 * (3 + 4);
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "21. Precedence" do
  #   source_code = """
  #                   int main() {
  #                     return 2 + 3 * 4;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "22. Sub neg" do
  #   source_code = """
  #                   int main() {
  #                     return 2- -1;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "23. Sub" do
  #   source_code = """
  #                   int main() {
  #                     return 1 - 2;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "24. Un op add" do
  #   source_code = """
  #                   int main() {
  #                     return ~2 + 3;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "25. Un op parens" do
  #   source_code = """
  #                   int main() {
  #                     return ~(1 + 1);
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # # Valid tests week 4  --------------------------------------------

  # test "26. And false" do
  #   source_code = """
  #                   int main() {
  #                     return 1 && 0;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "27. And true" do
  #   source_code = """
  #                   int main() {
  #                     return 1 && -1;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "28. Eq false" do
  #   source_code = """
  #                   int main() {
  #                     return 1 == 2;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "29. Eq true" do
  #   source_code = """
  #                   int main() {
  #                     return 1 == 1;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "30. Ge false" do
  #   source_code = """
  #                   int main() {
  #                     return 1 >= 2;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "31. Ge true" do
  #   source_code = """
  #                   int main() {
  #                     return 1 >= 1;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "32. Gt false" do
  #   source_code = """
  #                   int main() {
  #                     return 1 > 2;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "33. Gt true" do
  #   source_code = """
  #                   int main() {
  #                     return 1 > 0;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "34. Le false" do
  #   source_code = """
  #                   int main() {
  #                     return 1 <= -1;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "35. Le true" do
  #   source_code = """
  #                   int main() {
  #                     return 0 <= 2;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "36. Lt false" do
  #   source_code = """
  #                   int main() {
  #                     return 2 < 1;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "37. Lt true" do
  #   source_code = """
  #                   int main() {
  #                     return 1 < 2;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "38. Ne false" do
  #   source_code = """
  #                   int main() {
  #                     return 0 != 0;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "39. Ne true" do
  #   source_code = """
  #                   int main() {
  #                     return -1 != -2;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "40. Or false" do
  #   source_code = """
  #                   int main() {
  #                     return 0 || 0;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "41. Or true" do
  #   source_code = """
  #                   int main() {
  #                     return 1 || 0;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "42. Precedence" do
  #   source_code = """
  #                   int main() {
  #                     return 1 || 0 && 2;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "43. Precedence 2" do
  #   source_code = """
  #                   int main() {
  #                     return (1 || 0) && 0;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "44. Precedence 3" do
  #   source_code = """
  #                   int main() {
  #                     return 2 == 2 > 0;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

  # test "45. Precedence 4" do
  #   source_code = """
  #                   int main() {
  #                     return 2 == 2 || 0;
  #                   }
  #                 """
  #   assert Compiler.compiler_test(source_code) == :successfulComp
  # end

end
