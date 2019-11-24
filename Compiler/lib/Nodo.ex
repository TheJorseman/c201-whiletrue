defmodule Nodo do
  @moduledoc """
  Define la estrutura que va a tener un nodo del arbol AST.
  """
  defstruct name: nil, value: nil, left: nil, right: nil
  @type nodo(value) :: %Nodo{value: value}
  @type nodo :: %Nodo{value: Token.token(), left: Nodo.nodo(), right: Nodo.nodo()}
end

