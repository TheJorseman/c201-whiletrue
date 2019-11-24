defmodule Optimizer do
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
                optimizer_neg(ast_nodo,left,right)
              true ->
                ast_nodo = %{ast_nodo | left: left}
                %{ast_nodo | right: right}
            end
    end
  end

  def optimizer_neg(ast_nodo,left,right) do
    if left.name == :negation_minus and ast_nodo.name != :return and right == nil do
      left.left
    else
      ast_nodo = %{ast_nodo | left: left}
      %{ast_nodo | right: right}
    end
  end


  def optimizer_0(root) do
    IO.puts("=========Optimizer===========")
    result = o_posorder(root)
    IO.inspect(result)
    #return = o_negation(lista)
    #IO.inspect(return)
  end
end
