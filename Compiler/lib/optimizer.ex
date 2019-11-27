defmodule Optimizer do
  @moduledoc """
  Este modulo recibe un árbol ast y devuelve un arbol ast optimizado o codigo ensamblador.
  """
  @moduledoc since: "1.5.0"

  @doc """
  Función que recorre el arbol y dependiendo de éste se optimizará o no.
  ##Parámetros
    -nodo : Nodo del ast que se va a optimizar
  """
  def o_posorder(nodo) do
    case nodo do
        nil ->
            nil
        ast_nodo ->
            #IO.inspect(lista)
            left  = o_posorder(ast_nodo.left)
            right = o_posorder(ast_nodo.right)
            cond do
              left != nil ->
                ast_opt_neg = optimizer_neg(ast_nodo,left,right)
                ast_opt_ln = optimizer_log_neg(ast_opt_neg,ast_opt_neg.left,ast_opt_neg.right)
                optimizer_bitwiseN(ast_opt_ln,ast_opt_ln.left,ast_opt_ln.right)
              true ->
                ast_nodo = %{ast_nodo | left: left}
                %{ast_nodo | right: right}
            end
    end
  end
  @doc """
  Optimiza la negacion lógica de tal manera que si encuentra tres negaciones seguidas
  se reducirá a una. Por ejemplo !!!5, esto primero dará 0, luego 1 y finalmente 0 por lo que
  es mas optimo solo utilizar una vez el !. Asimismo con numeros paresde negacion como:
  !!!!5 lo cual dara como resultado !!5.
  Si se cumple la condicion regresará el la expresion antes mencionada.
  Si no, entonces regresará un nodo con sus hijos left y right optimizados si asi sea.
  ##Parámetros
    -ast_nodo : Se refiere al nodo actual
    -left     : Hijo izquierdo del nodo actual optimizado o no.
    -right    : Hijo derecho del nodo actual optimizado o no.
  """
  def optimizer_log_neg(ast_nodo,left,right) do
    if ast_nodo.name == :logicalN do
      if left != nil and left.name == :logicalN do
        left_1 = left.left
        if left_1 != nil and left_1.name == :logicalN do
          ast_nodo = %{ast_nodo | left: left_1.left}
          %{ast_nodo | right: right}
        else
          ast_nodo = %{ast_nodo | left: left}
          %{ast_nodo | right: right}
        end
      else
        ast_nodo = %{ast_nodo | left: left}
        %{ast_nodo | right: right}
      end
    else
      ast_nodo = %{ast_nodo | left: left}
      %{ast_nodo | right: right}
    end
  end

  @doc """
  Optimiza la negacion en dado caso que sea posible.
  Reeplaza el nodo dado la siguiente regla:
  Si hay una expresion --5 regresará 5 y asi de manera ascendente en el árbol.
  ##Parámetros
    -ast_nodo : Se refiere al nodo actual
    -left     : Hijo izquierdo del nodo actual optimizado o no.
    -right    : Hijo derecho del nodo actual optimizado o no.
  """
  def optimizer_neg(ast_nodo,left,right) do
    if ast_nodo.name == :negation_minus do
      if left.name == :negation_minus do
        left.left
      else
        ast_nodo = %{ast_nodo | left: left}
        %{ast_nodo | right: right}
      end
    else
      ast_nodo = %{ast_nodo | left: left}
      %{ast_nodo | right: right}
    end
  end
  @doc """
  Optimiza el bitwise negation en dado caso que sea posible.
  Reeplaza el nodo dado la siguiente regla:
  Si hay una expresion ~~5 regresará 5 y asi de manera ascendente en el árbol.
  ##Parámetros
    -ast_nodo : Se refiere al nodo actual
    -left     : Hijo izquierdo del nodo actual optimizado o no.
    -right    : Hijo derecho del nodo actual optimizado o no.
  """
  def optimizer_bitwiseN(ast_nodo,left,right) do
    if ast_nodo.name == :bitwiseN do
      if left.name == :bitwiseN do
        left.left
      else
        ast_nodo = %{ast_nodo | left: left}
        %{ast_nodo | right: right}
      end
    else
      ast_nodo = %{ast_nodo | left: left}
      %{ast_nodo | right: right}
    end
  end

# Optimizador agresivo :v
  @doc """
  Función que recorre el arbol y realizará todas las operaciones para regresar un único valor.
  ##Parámetros
    -nodo : Nodo del ast que se va a optimizar
  """
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

def getCode(:constant,value,_,_) do
  elem(value,1)
end

def getCode(:multiplication,_,code,code_r) do
  code * code_r
end

def getCode(:addition,_,code,code_r) do
  code + code_r
end

def getCode(:equal,_,code,code_r) do
  if code == code_r do
    1
  else
    0
  end
end

def getCode(:notEqual,_,code,code_r) do
  if code != code_r do
    1
  else
    0
  end
end

def getCode(:greaterThanEq,_,code,code_r) do
  if code >= code_r do
    1
  else
    0
  end
end

def getCode(:greaterThan,_,code,code_r) do
  if code > code_r do
    1
  else
    0
  end
end

def getCode(:lessThan,_,code,code_r) do
  if code < code_r do
    1
  else
    0
  end
end

def getCode(:lessThanEq,_,code,code_r) do
  if code <= code_r do
    1
  else
    0
  end
end

def getCode(:orT,_,code,code_r) do
  if code == 1 and code_r == 1 do
    1
  else
    0
  end
end

def getCode(:andT,_,code,code_r) do
  if code == 0 or code_r == 0 do
    0
  else
    1
  end
  #code and code_r
end

def getCode(:division,_,code,code_r) do
  code / code_r
end
def getCode(:negation_minus,_,code,code_r) do
  IO.puts(code_r)
  if code_r == nil do
    -code
  else
    code - code_r
  end
end

def getCode(:bitwiseN,_,code,_) do
  use Bitwise
  bnot(code)
end

def getCode(:logicalN,_,code,_) do
  if code == 0 do
    1
  else
    0
  end
end

def getCode(:return,_,code,_) do
  value = Integer.to_string(code)
  "
          mov $#{value}, %rax
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


  @doc """
  Función que manda a llamar a la funcion correspondiente para realizar la optimizacion.
  ##Parámetros
    -nodo : Nodo del ast que se va a optimizar
  """
  def optimizer_1(root) do
    o_posorder(root)
  end
  @doc """
  Función que manda a llamar a las funciones de optimizacion
  ##Parámetros
    -nodo : Nodo del ast que se va a optimizar
  """
  def optimizer_2(root) do
    ast_opt = optimizer_1(root)
    code = posorder(ast_opt)
    IO.puts(code)
    code
  end
  def optimizer_2C(root) do
    ast_opt = optimizer_1(root)
    code = posorder(ast_opt)
    IO.inspect(code)  end
end
