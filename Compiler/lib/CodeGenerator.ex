defmodule CodeGenerator do
    def posorder(nodo) do
        #IO.inspect nodo.name
        case nodo do
            nil ->
                nil
            ast_nodo ->
                code = posorder(ast_nodo.left)
                #posorder(ast_nodo.right)
                getCode(ast_nodo.name,ast_nodo.value,code)
        end
    end

    def getCode(:constant,value,_) do
        "$" <>  Integer.to_string( elem(value,1) )
    end

    def getCode(:return,_,code) do
        "movl #{code}, %eax
        ret
         "
    end

    def getCode(:function,value,code) do
        function_code = ".globl " <> elem(value,1) <> "
     "<> elem(value,1) <>":
        "<> code
    end

    def getCode(:program,_,code) do
        program = "

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
