defmodule CodeGenerator do
    def posorder(nodo) do
        #IO.inspect nodo.name
        case nodo do
            nil ->
                nil
            ast_nodo ->
              # IO.inspect(ast_nodo)
                code = posorder(ast_nodo.left)
                code_r = posorder(ast_nodo.right)
                getCode(ast_nodo.name,ast_nodo.value,code,code_r)
        end
    end

    def print_ast(ast_nodo,sep) do
        if ast_nodo.value != nil do
            {name,value,_} = ast_nodo.value
            cond do
                name == :constant ->
                    print = sep <> Integer.to_string(value)
                    IO.puts(print)
                name in [:addition,:negation_minus, :multiplication, :division, :identifier, :logicalN, :bitwiseN] ->
                    IO.puts(sep <> value)
                true ->
                    IO.puts(sep <> Atom.to_string(ast_nodo.name))
            end
        else
            print = sep <> Atom.to_string(ast_nodo.name)
            IO.puts(print)
        end
    end

    def pretty_printing(nodo,sep) do
        #IO.inspect nodo.name
        case nodo do
            nil ->
                nil
            ast_nodo ->

                pretty_printing(ast_nodo.right,sep <> "\t")
                print_ast(ast_nodo,sep)
                pretty_printing(ast_nodo.left, sep <> "\t")
        end
    end

    def getCode(:constant,value,_,_) do
        "mov "<>"$" <>  Integer.to_string( elem(value,1) ) <> ", %rax"
    end

    def getCode(:multiplication,_,code,code_r) do
        """
                        #{code}
                        push %rax
                        #{code_r}
                        pop %rbx
                        imul %rbx, %rax
        """
    end

    def getCode(:addition,_,code,code_r) do
        """
                        #{code}
                        push %rax
                        #{code_r}
                        pop %rbx
                        add %rbx, %rax
        """
    end

    def getCode(:equal,_,code,code_r) do
        """
                        #{code}
                        push %rax
                        #{code_r}
                        pop %rbx
                        cmp %rax, %rbx
                        mov $0, %rax
                        sete %al
        """
    end

    def getCode(:notEqual,_,code,code_r) do
        """
                        #{code}
                        push %rax
                        #{code_r}
                        pop %rbx
                        cmp %rax, %rbx
                        mov $0, %rax
                        setne %al
        """
    end

    def getCode(:greaterThanEq,_,code,code_r) do
        """
                        #{code}
                        push %rax
                        #{code_r}
                        pop %rbx
                        cmp %rax, %rbx
                        mov $0, %rax
                        setge %al
        """
    end

    def getCode(:greaterThan,_,code,code_r) do
        """
                        #{code}
                        push %rax
                        #{code_r}
                        pop %rbx
                        cmp %rax, %rbx
                        mov $0, %rax
                        setg %al
        """
    end

    def getCode(:lessThan,_,code,code_r) do
        """
                        #{code}
                        push %rax
                        #{code_r}
                        pop %rbx
                        cmp %rax, %rbx
                        mov $0, %rax
                        setl %al
        """
    end

    def getCode(:lessThanEq,_,code,code_r) do
        """
                        #{code}
                        push %rax
                        #{code_r}
                        pop %rbx
                        cmp %rax, %rbx
                        mov $0, %rax
                        setle %al
        """
    end

    def getCode(:orT,_,code,code_r) do
        """
                        #{code}
                        cmp $0, %rax
                        je _clause2
                        mov $1,%rax
                        jmp _end
                    _clause2:
                        #{code_r}
                        cmp $0, %rax
                        mov $0, %rax
                        setne %al
                    _end:
        """
    end

    def getCode(:andT,_,code,code_r) do
        """
                        #{code}
                        cmp $0, %rax
                        jne _clause2
                        jmp _end
                    _clause2:
                        #{code_r}
                        cmp $0, %rax
                        mov $0, %rax
                        setne %al
                    _end:
        """
    end

    def getCode(:division,_,code,code_r) do
        """
                        #{code}
                        push %rax
                        #{code_r}
                        pop %rbx
                        xchg %rax, %rbx
                        cqo
                        idiv %rbx
        """
    end
    def getCode(:negation_minus,_,code,code_r) do
        IO.puts(code_r)
        if code_r == nil do
            """
            #{code}
                            neg %rax
            """
        else
            """
                            #{code}
                            push %rax
                            #{code_r}
                            pop %rbx
                            sub %rax, %rbx
                            mov %rbx, %rax
            """
        end
    end

    def getCode(:bitwiseN,_,code,_) do
        """
        #{code}
                        not %rax
        """
    end

    def getCode(:logicalN,_,code,_) do
        """
        #{code}
                        cmp $0, %rax
                        xor $0, %rax
                        sete %al
        """
    end

    def getCode(:return,_,code,_) do
        "
                #{code}
            ret
         "
    end

    def getCode(:function,value,code,_) do
        ".globl " <> elem(value,1) <>
        "
            "<> elem(value,1) <>":"<> code
    end

    def getCode(:program,_,code,_) do
        "
        #{code}
        "
    end

    def generateCode (root) do
        pretty_printing(root,"")
        assembly_code = posorder(root)
        IO.puts("\nCode generator Output:")
        IO.puts(assembly_code)
        assembly_code
    end
end
