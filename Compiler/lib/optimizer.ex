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
                ast_opt_neg = optimizer_neg(ast_nodo,left,right)
                ast_opt_ln = optimizer_log_neg(ast_opt_neg,ast_opt_neg.left,ast_opt_neg.right)
                optimizer_bitwiseN(ast_opt_ln,ast_opt_ln.left,ast_opt_ln.right)
              true ->
                ast_nodo = %{ast_nodo | left: left}
                %{ast_nodo | right: right}
            end
    end
  end

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

  def optimizer_0(root) do
    IO.puts("=========Optimizer===========")
    result = o_posorder(root)
    IO.inspect(result)
    #return = o_negation(lista)
    #IO.inspect(return)
  end
end
