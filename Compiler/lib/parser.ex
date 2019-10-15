defmodule Parser do

  def parseProgram(tokens) do
    root = %Nodo{name: :program }
    root = parseFunction(tokens,root)
  end

  def parseFunction(tokens,root) do
    #Check int
    {intKey,tokens} = List.pop_at(tokens,0)
    if elem(intKey,0) != :intKeyword do
      raise "Syntax Error: int keyword expected at " <> Integer.to_string(elem(intKey,2)) <>" line."
    end
    #Check main
    {name,tokens} = List.pop_at(tokens,0)
    if {elem(name,0), elem(name,1)} != {:identifier,"main"} do
      raise "Syntax Error: main" <> " keyword expected at " <> Integer.to_string(elem(name,2))<>" line."
    end
    function = %Nodo{name: :function ,value: name}
    #Check (
    {nexTok,tokens }= List.pop_at(tokens,0)
    if elem(nexTok,0) != :openParen do
      raise "Syntax Error: (" <> " keyword expected at " <> Integer.to_string(elem(nexTok,2)) <>" line."
    end
    #Check )
    {nexTok,tokens } = List.pop_at(tokens,0)
    if elem(nexTok,0) != :closeParen do
      raise "Syntax Error: )" <> " keyword expected at " <> Integer.to_string(elem(nexTok,2)) <>" line."
    end
    #Check {
    {nexTok,tokens}= List.pop_at(tokens,0)
    if elem(nexTok,0) != :openBrace do
      raise "Syntax Error: {" <> " keyword expected at " <> Integer.to_string(elem(nexTok,2)) <>" line."
    end
    #Check Statement
    {tokens,function} = parseStatement(tokens,function)
    #Check }
    {nexTok,tokens}= List.pop_at(tokens,0)
    if elem(nexTok,0) != :closeBrace do
      raise "Syntax Error: }" <> " keyword expected at " <> Integer.to_string(elem(nexTok,2)) <>" line."
    end
    root = %{root | left: function }
  end

  def parseStatement(tokens,root) do
    {nexTok,tokens } = List.pop_at(tokens,0)
    if elem(nexTok,0) != :returnKeyword do
      raise "Syntax Error return" <> " keyword expected at " <> Integer.to_string(elem(nexTok,2)) <>" line."
    end
    statement = %Nodo{name: :return, value: nexTok}
    #PARSE Exp
    {tokens,statement} = parseExp(tokens,statement)
    {nexTok,tokens} = List.pop_at(tokens,0)
    IO.inspect(nexTok)
    if elem(nexTok,0) != :semicolon do
      raise "Syntax Error Semicolon" <> " keyword expected at " <> Integer.to_string(elem(nexTok,2)) <> " line"
    end
      root = %{root | left: statement}
    {tokens,root}
  end

  def parseExp(tokens,root) do
    {nexTok,tokens}  = List.pop_at(tokens,0)
    currToken = elem(nexTok,0)
    if currToken == :constant do
      constant = %Nodo{name: :constant, value: nexTok}
      root = %{root | left: constant}
      {tokens,root}
    else
      if check_unary_op(currToken) == True do
        exp = %Nodo{name: currToken, value: nexTok}
        {tokens,inner_exp} = parseExp(tokens,exp)
        root = %{root | left: inner_exp}
        {tokens,root}
      else
        raise "Syntax Error Unary operator" <> " keyword expected at " <> Integer.to_string(elem(nexTok,2)) <>" line."
      end
    end
  end
  def check_unary_op(currToken) do
    if currToken == :negation or currToken == :bitwiseN or currToken == :logicalN do
      True
    else
      False
    end
  end

end
