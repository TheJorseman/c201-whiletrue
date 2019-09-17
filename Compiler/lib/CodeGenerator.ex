defmodule CodeGenerator do
    def posorder(nodo) do
        #IO.inspect nodo.name
        case nodo do
            nil ->
                nil
            ast_nodo ->
                code = posorder(ast_nodo.left)
                #posorder(ast_nodo.right)
                IO.inspect nodo.name
                getCode(ast_nodo.name,ast_nodo.value,code)
        end 
    end

    def getCode(:constant,value,_) do
        "%" <>  Integer.to_string( elem(value,1) )
    end

    def getCode(:return,_,code) do
        "   movl #{code}, %eax
           retq
         "
    end

    def getCode(:function,value,code) do
        function_code = ".globl " <> elem(value,1) <> "
        _"<> elem(value,1) <>"
        "<> code
    end

    def getCode(:program,_,code) do
        program = "
        .section        __TEXT, __text, regular, pure_instructions
        .p2align        4, 0x90
        #{code}
        .subsections_via_symbols
        "
    end

    def generateCode (root) do
        assembly_code = posorder(root)
        IO.puts assembly_code
        IO.inspect assembly_code
    end
end