defmodule Nodo do
  defstruct name: nil, value: nil, left: nil, right: nil
  @type nodo(value) :: %Nodo{value: value}
  @type nodo :: %Nodo{value: Token.token(), left: Nodo.nodo(), right: Nodo.nodo()}
end

