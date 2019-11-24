defmodule Parser do
  @moduledoc """
  Este modulo recibe una lista de tokens y regresa un arbol ast con la gramatica:
  '
  <program> ::= <function>
  <function> ::= "int" <id> "(" ")" "{" <statement> "}"
  <statement> ::= "return" <exp> ";"
  <exp> ::= <logical-and-exp> { "||" <logical-and-exp> }
  <logical-and-exp> ::= <equality-exp> { "&&" <equality-exp> }
  <equality-exp> ::= <relational-exp> { ("!=" | "==") <relational-exp> }
  <relational-exp> ::= <additive-exp> { ("<" | ">" | "<=" | ">=") <additive-exp> }
  <additive-exp> ::= <term> { ("+" | "-") <term> }
  <term> ::= <factor> { ("*" | "/") <factor> }
  <factor> ::= "(" <exp> ")" | <unary_op> <factor> | <int>
  <unary_op> ::= "!" | "~" | "-"
  '
  """
  @moduledoc since: "1.5.0"

  @doc """
  Corresponde a la funcion que hace el parse de program
  """
  def parseProgram(tokens) do
    root = %Nodo{name: :program}
    function = parseFunction(tokens)
    %{root | left: function }
    #IO.inspect(root)
  end
  @doc """
  Corresponde a la funcion que hace el parse de Function
  """
  def parseFunction(tokens) do
    #Check int
    {intKey,tokens} = List.pop_at(tokens,0)
    if elem(intKey,0) != :intKeyword do
      raise "Syntax Error: int keyword expected at line " <> Integer.to_string(elem(intKey,2))
    end
    #Check main
    {name,tokens} = List.pop_at(tokens,0)
    if {elem(name,0), elem(name,1)} != {:identifier,"main"} do
      raise "Syntax Error: main" <> " keyword expected at line " <> Integer.to_string(elem(name,2))
    end
    function = %Nodo{name: :function ,value: name}
    #Check (
    {nexTok,tokens }= List.pop_at(tokens,0)
    if elem(nexTok,0) != :openParen do
      raise "Syntax Error: (" <> " keyword expected at line " <>  Integer.to_string(elem(nexTok,2))
    end
    #Check )
    {nexTok,tokens } = List.pop_at(tokens,0)
    if elem(nexTok,0) != :closeParen do
      raise "Syntax Error: )" <> " keyword expected at line " <> Integer.to_string(elem(nexTok,2))
    end
    #Check {      #{_,tokens}  = List.pop_at(tokens,0)
    {nexTok,tokens}= List.pop_at(tokens,0)
    if nexTok == nil or elem(nexTok,0) != :openBrace do
      raise "Syntax Error: {" <> " keyword expected at line " <> Integer.to_string(elem(nexTok,2))
    end
    #Check Statement
    {tokens,statement} = parseStatement(tokens)
    function = %{function | left: statement}
    #IO.inspect(tokens)
    #Check }
    {nexTok,_}= List.pop_at(tokens,0)
    if elem(nexTok,0) != :closeBrace do
      raise "Syntax Error: }" <> " keyword expected at line " <> Integer.to_string(elem(nexTok,2))
    end
    function
  end
  @doc """
  Corresponde a la funcion que hace el parse de statement
  """
  def parseStatement(tokens) do
    {nexTok,tokens } = List.pop_at(tokens,0)
    if elem(nexTok,0) != :returnKeyword do
      raise "Syntax Error return" <> " keyword expected at line " <> Integer.to_string(elem(nexTok,2))
    end
    statement = %Nodo{name: :return, value: nexTok}
    #PARSE Exp
    {tokens,exp} = parseExp(tokens)
    statement = %{statement | left: exp}
    {nexTok,tokens} = List.pop_at(tokens,0)
    # IO.inspect(nexTok)
    #   IO.inspect(tokens)
    if elem(nexTok,0) != :semicolon do
      raise "Syntax Error Semicolon" <> " keyword expected at line " <> Integer.to_string(elem(statement.left.value,2))
    end
    if tokens != [] do
      {tokens,statement}
    else
      {[{:error,"",elem(nexTok,2)}],nil}
    end
  end
  @doc """
  Corresponde a la funcion que hace el parse de expression
  """
  def parseExp(tokens) do
    #IO.puts("ParseExp")
    # <parseLogicalAndExp> { || <parseLogicalAndExp>}
    {tokens,term} = parseLogicalAndExp(tokens);
    while_parse(tokens,term,[:orT],:parseLogicalAndExp)
  end
  @doc """
  Corresponde a la funcion que hace el parse de logical and exp
  """
  def parseLogicalAndExp(tokens) do
    # <parseEqualityExp> { && <parseEqualityExp>}
    {tokens,term} = parseEqualityExp(tokens);
    while_parse(tokens,term,[:andT],:parseEqualityExp)
  end

  @doc """
  Corresponde a la funcion que hace el parse de equality exp
  """
  def parseEqualityExp(tokens) do
    # <relational-exp> { != | == <relational-exp>}
    {tokens,term} = parseRelationalExp(tokens);
    while_parse(tokens,term,[:equal, :notEqual],:parseRelationalExp)
  end

  @doc """
  Corresponde a la funcion que hace el parse de relational exp
  """
  def parseRelationalExp(tokens) do
    # <additive-exp> { <|>|>=|<= <additive-exp>}
    {tokens,term} = parseAdditiveExp(tokens);
    while_parse(tokens,term,[:lessThan, :greaterThan, :greaterThanEq, :lessThanEq],:parseAdditiveExp)
  end
  @doc """
  Corresponde a la funcion que hace el parse de additive exp
  """
  def parseAdditiveExp(tokens) do
    # <term> { (+ | - ) <term> }
    {tokens,term} = parseTerm(tokens);
    while_parse(tokens,term,[:addition,:negation_minus],:parseTerm)
  end
  @doc """
  Esta funcion hace el papel de un while recursivo el cual dependiendo de los
  parametros va a hacer una busqueda hacia adelante en busca de mas expresiones
  del tipo de los parámetros y como se indica en la gramática.
  ## Parámetros
    -tokens   : Corresponde a la lista de tokens reconocidos en procesos previos como el lexer.
    -term     : Corresponde a una parte del arbol ast para añadir mas elementos al arbol como padre.
    -list     : Corresponde a la lista de tokens en la que debe de estar el siguiente token a ser evaluado.
    -function : Corresponde a la funcion que se va a evaluar recursivamente.
  """
  def while_parse(tokens,term,list,function) when tokens != [] do
    [head | tail ] = tokens
    nextToken = elem(head,0)
    if nextToken in list do
      tokens = tail
      cond do
        function == :parseLogicalAndExp ->
          {tokens,nextTerm} = parseLogicalAndExp(tokens)
          binary_op = %Nodo{name: nextToken, value: head, left: term, right: nextTerm}
          #IO.inspect(binary_op)
          while_parse(tokens,binary_op,list,function)
        function == :parseEqualityExp ->
          {tokens,nextTerm} = parseEqualityExp(tokens)
          binary_op = %Nodo{name: nextToken, value: head, left: term, right: nextTerm}
          #IO.inspect(binary_op)
          while_parse(tokens,binary_op,list,function)
        function == :parseRelationalExp ->
          #IO.inspect(head)
          #IO.inspect(nextToken)
          {tokens,nextTerm} = parseRelationalExp(tokens)
          #IO.inspect(nextTerm)
          binary_op = %Nodo{name: nextToken, value: head, left: term, right: nextTerm}
          #IO.inspect(binary_op)
          while_parse(tokens,binary_op,list,function)
        function == :parseAdditiveExp ->
          {tokens,nextTerm} = parseAdditiveExp(tokens)
          binary_op = %Nodo{name: nextToken, value: head, left: term, right: nextTerm}
          #IO.inspect(binary_op)
          while_parse(tokens,binary_op,list,function)
        function == :parseTerm ->
          {tokens,nextTerm} = parseTerm(tokens)
          binary_op = %Nodo{name: nextToken, value: head, left: term, right: nextTerm}
          #IO.inspect(binary_op)
          while_parse(tokens,binary_op,list,function)
        function == :parseFactor ->
          {tokens,nextTerm} = parseFactor(tokens)
          binary_op = %Nodo{name: nextToken, value: head, left: term, right: nextTerm}
          #IO.inspect(binary_op)
          while_parse(tokens,binary_op,list,function)
        true ->
          raise "Error: el programador puso mal la funcion :("
      end
    else
      {tokens,term}
    end
  end
  @doc """
  Corresponde a la funcion que hace el parse de term
  """
  def parseTerm(tokens) do
    #<factor> {( * | / )  <factor>}
    {tokens,factor} = parseFactor(tokens);
    while_parse(tokens,factor,[:multiplication,:division],:parseFactor)
  end
  @doc """
  Corresponde a la funcion que hace el parse de factor
  """
  def parseFactor(tokens) do
    #IO.puts("ParseFactor")
    # ( <exp> ) | <unary_op> <factor> | <int>
    {nexTok,tokens}  = List.pop_at(tokens,0)
    currToken = elem(nexTok,0)
    #IO.inspect(currToken)
    cond do
      currToken == :openParen ->
        # ( <exp> )
        #composed = %Nodo{name: currToken, value: nexTok}
        {tokens,exp} = parseExp(tokens)
        #composed = %{composed | left: exp}
        #Ccheck if ")"
        {nexTok,tokens}  = List.pop_at(tokens,0)
        currToken = elem(nexTok,0)
        if currToken != :closeParen do
          raise "Syntax Error '(' keyword expected at line " <> Integer.to_string(elem(nexTok,2))
        end
        {tokens,exp}
      check_unary_op(currToken) == True ->
        unary = %Nodo{name: currToken, value: nexTok}
        {tokens,inner_exp} = parseFactor(tokens)
        unary = %{unary | left: inner_exp}
        {tokens,unary}
      currToken == :constant ->
        constant = %Nodo{name: :constant, value: nexTok}
        {tokens,constant}
      true ->
        #IO.inspect(nexTok)
        raise "Syntax Error before '"<>elem(nexTok,1)<>"' Unary operator or constant keyword expected at line " <> Integer.to_string(elem(nexTok,2))
    end
  end
  @doc """
  Funcion que recibe un atomo de un token y revuelve True o False si es que es un operador unario
  """
  def check_unary_op(currToken) do
    if currToken == :negation_minus or currToken == :bitwiseN or currToken == :logicalN do
      True
    else
      False
    end
  end
end

