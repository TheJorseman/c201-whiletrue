defmodule CodeGenerator do
  @moduledoc """
  Este modulo recibe un árbol ast y devuelve un string con el codigo ensamblador correspondiente.
  """
  @moduledoc since: "1.5.0"
  @doc """
  Funcion recursiva que recorre el arbol en pos orden y que regresa el codigo ensamblador.
  ## Parámetros
    -nodo : corresponde con el nodo actual y el que va a ser navegado.
  """
    def posorder(nodo) do
        case nodo do
            nil ->
                nil
            ast_nodo ->
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

    @doc """
    Funcion que regresa el código ensamblador de una constante.
    """
    def getCode(:constant,value,_,_) do
        "\n\t\tmov "<>"$" <>  Integer.to_string( elem(value,1) ) <> ", %rax"
    end
    @doc """
    Funcion que regresa el código ensamblador de la multiplicacion.
    """
    def getCode(:multiplication,_,code,code_r) do
        """
                        #{code}
                        push %rax
                        #{code_r}
                        pop %rbx
                        imul %rbx, %rax
        """
    end
    @doc """
    Funcion que regresa el código ensamblador de la suma.
    """
    def getCode(:addition,_,code,code_r) do
        """
                        #{code}
                        push %rax
                        #{code_r}
                        pop %rbx
                        add %rbx, %rax
        """
    end
    @doc """
    Funcion que regresa el código ensamblador del operador igual '=='.
    """
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

    @doc """
    Funcion que regresa el código ensamblador de '!=' .
    """
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
    @doc """
    Funcion que regresa el código ensamblador de >=.
    """
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
    @doc """
    Funcion que regresa el código ensamblador de >.
    """
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
    @doc """
    Funcion que regresa el código ensamblador de <s=.
    """
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
    @doc """
    Funcion que regresa el código ensamblador de <=.
    """
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
    @doc """
    Funcion que regresa el código ensamblador de or ó || .
    """
    def getCode(:orT,_,code,code_r) do
        lista_1 = Regex.scan(~r/clause_or\d{1,}/,code)
        lista_2 = Regex.scan(~r/clause_or\d{1,}/,code_r)
        num = Integer.to_string( length(lista_1) + length(lista_2) + 1 )

        """
                        #{code}
                        cmp $0, %rax
                        je clause_or#{num}
                        mov $1,%rax
                        jmp end_or#{num}
                    clause_or#{num}:
                        #{code_r}
                        cmp $0, %rax
                        mov $0, %rax
                        setne %al
                    end_or#{num}:
        """
    end
    @doc """
    Funcion que regresa el código ensamblador de and ó &&.
    """
    def getCode(:andT,_,code,code_r) do
        lista_1 = Regex.scan(~r/clause_and\d{1,}/,code)
        lista_2 = Regex.scan(~r/clause_and\d{1,}/,code_r)
        num = Integer.to_string( length(lista_1) + length(lista_2) + 1 )
        """
                        #{code}
                        cmp $0, %rax
                        jne clause_and#{num}
                        jmp end_and#{num}
                    clause_and#{num}:
                        #{code_r}
                        cmp $0, %rax
                        mov $0, %rax
                        setne %al
                    end_and#{num}:
        """
    end
    @doc """
    Funcion que regresa el código ensamblador de division.
    """
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

    @doc """
    Funcion que regresa el código ensamblador de la negacion o resta.
    """
    def getCode(:negation_minus,_,code,code_r) do
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
    @doc """
    Funcion que regresa el código ensamblador de ~.
    """
    def getCode(:bitwiseN,_,code,_) do
        """
        #{code}
                        not %rax
        """
    end
    @doc """
    Funcion que regresa el código ensamblador de !.
    """
    def getCode(:logicalN,_,code,_) do
        """
        #{code}
                        cmp $0, %rax
                        xor $0, %rax
                        sete %al
        """
    end
    @doc """
    Funcion que regresa el código ensamblador de return.
    """
    def getCode(:return,_,code,_) do
        "
                #{code}
            ret
         "
    end
    @doc """
    Funcion que regresa el código ensamblador de funcion.
    """
    def getCode(:function,value,code,_) do
        ".globl " <> elem(value,1) <>
        "
            "<> elem(value,1) <>":"<> code
    end
    @doc """
    Funcion que regresa el código ensamblador de program.
    """
    def getCode(:program,_,code,_) do
        "
        #{code}
        "
    end
    @doc """
    Funcion que genera el código ensabmblador a partir de un nodo.
    """
    def generateCode (root) do
        IO.puts("\nAST Tree:")
        pretty_printing(root,"")
        assembly_code = posorder(root)
        assembly_code
    end
    @doc """
    Funcion que regresa el codigo ensamblador sin imprimir el arbol.
    """
    def generateCodeNoP (root) do
        assembly_code = posorder(root)
        assembly_code
    end
end
