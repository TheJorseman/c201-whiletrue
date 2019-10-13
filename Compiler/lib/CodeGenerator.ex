defmodule CodeGenerator do
    def posorder(nodo) do
        #IO.inspect nodo.name
        case nodo do
            nil ->
                nil
            ast_nodo ->
                IO.inspect(ast_nodo)
                code = posorder(ast_nodo.left)
                #posorder(ast_nodo.right)
                IO.inspect(ast_nodo)
                getCode(ast_nodo.name,ast_nodo.value,code)
        end
    end

    def getCode(:constant,value,_) do
        "movl "<>"$" <>  Integer.to_string( elem(value,1) ) <> ", %eax"
    end

    def getCode(:negation,_,code) do
        """
        #{code}
                        neg %eax
        """
    end

    def getCode(:bitwiseN,_,code) do
        """
        #{code}
                        notl %eax
        """
    end

    def getCode(:logicalN,_,code) do
        """
        #{code}
                        cmpl $0, %eax
                        xor $0, %eax
                        sete %al
        """
    end

    def getCode(:return,_,code) do
        "
                #{code}
            ret
         "
    end

    def getCode(:function,value,code) do
        ".globl " <> elem(value,1) <>
        "
            "<> elem(value,1) <>":"<> code
    end

    def getCode(:program,_,code) do
        "

        #{code}

        "
    end

    def generateCode (root) do
        assembly_code = posorder(root)
        IO.puts("\nCode generator Output:")
        IO.puts(assembly_code)
        assembly_code
    end
end
