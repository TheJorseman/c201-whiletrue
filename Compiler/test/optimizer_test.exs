defmodule OPTIMIZERTest do
  use ExUnit.Case
  doctest Compiler

  test "1. Negation (5)" do
    source_code = """
                  int main() {
                    return -----2;
                  }
                  """
    asm = "\n        .globl main\n            main:\n                \n\t\tmov $2, %rax\n                neg %rax\n\n            ret\n         \n        "

    assert Compiler.optimizer_test(source_code) == asm
  end

  test "2. Negation (4)" do
    source_code = """
                  int main() {
                    return ----2;
                  }
                  """
    asm = "\n        .globl main\n            main:\n                \n\t\tmov $2, %rax\n            ret\n         \n        "
    assert Compiler.optimizer_test(source_code) == asm
  end

  test "3. Logical negation (3)" do
    source_code = """
                  int main() {
                    return !!!2;
                  }
                  """
    asm = "\n        .globl main\n            main:\n                \n\t\tmov $2, %rax\n                cmp $0, %rax\n                xor $0, %rax\n                sete %al\n\n            ret\n         \n        "
    assert Compiler.optimizer_test(source_code) == asm
  end

  test "4. Logical negation (6)" do
    source_code = """
                  int main() {
                    return !!!!!!2;
                  }
                  """
    asm = "\n        .globl main\n            main:\n                \n\t\tmov $2, %rax\n                cmp $0, %rax\n                xor $0, %rax\n                sete %al\n\n                cmp $0, %rax\n                xor $0, %rax\n                sete %al\n\n            ret\n         \n        "
    assert Compiler.optimizer_test(source_code) == asm
  end

  test "5. Bitwise complement (4)" do
    source_code = """
                  int main() {
                    return ~~~~2;
                  }
                  """
    asm = "\n        .globl main\n            main:\n                \n\t\tmov $2, %rax\n            ret\n         \n        "
    assert Compiler.optimizer_test(source_code) == asm
  end

  test "6. Bitwise complement (7)" do
    source_code = """
                  int main() {
                    return ~~~~~~~2;
                  }
                  """
    asm = "\n        .globl main\n            main:\n                \n\t\tmov $2, %rax\n                not %rax\n\n            ret\n         \n        "
    assert Compiler.optimizer_test(source_code) == asm
  end
end
