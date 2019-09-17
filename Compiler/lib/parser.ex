defmodule Parser do

def parseProgram(tokens) do
  root = %Nodo{name: :program }
  root = parseFunction(tokens,root)

end

def parseFunction(tokens,root) do
  #Check int
  {intKey,tokens} = List.pop_at(tokens,0)
  if intKey != Token.intKeyword() do
    raise "Syntax Error int keyword expected"
  end
  #Check main
  {name,tokens} = List.pop_at(tokens,0)
  if name != Token.identifier("main") do
    raise "Syntax Error main"
  end
  function = %Nodo{name: :function ,value: name}
  #Check (
  {nexTok,tokens }= List.pop_at(tokens,0)
  if nexTok != Token.openParen() do
    raise "Syntax Error ("
  end
  #Check )
  {nexTok,tokens } = List.pop_at(tokens,0)
  if nexTok != Token.closeParen() do
    raise "Syntax Error )"
  end
  #Check {
  {nexTok,tokens}= List.pop_at(tokens,0)
  if nexTok != Token.openBrace do
    raise "Syntax Error {"
  end
  #Check Statement
  {tokens,function} = parseStatement(tokens,function)
  #Check }
  {nexTok,tokens}= List.pop_at(tokens,0)
  if nexTok != Token.closeBrace do
    raise "Syntax Error }"
  end
  root = %{root | left: function }
end

def parseStatement(tokens,root) do
  {nexTok,tokens } = List.pop_at(tokens,0)
  if nexTok != Token.returnKeyword() do
    raise "Syntax Error return"
  end
  statement = %Nodo{name: :return, value: nexTok}
  #PARSE INT
  {tokens,statement} = parseInt(tokens,statement)
  {nexTok,tokens} = List.pop_at(tokens,0)
  if nexTok != Token.semicolon() do
    raise "Syntax Error Semicolon"
  end
  root = %{root | left: statement}
  {tokens,root}
end

def parseInt(tokens,root) do
  {nexTok,tokens}  = List.pop_at(tokens,0)
  if elem(nexTok,0) != :constant do
    raise "Syntax Error Constant"
  end
  constant = %Nodo{name: :constant, value: nexTok}
  root = %{root | left: constant}
  {tokens,root}
end

end

