defmodule Parser do

  def parseProgram(tokens) do
    root = %Nodo{name: :program}
    function = parseFunction(tokens)
    %{root | left: function }
    #IO.inspect(root)
  end

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
    IO.inspect(nexTok)
    IO.inspect(tokens)
    if elem(nexTok,0) != :semicolon do
      raise "Syntax Error Semicolon" <> " keyword expected at line " <> Integer.to_string(elem(statement.left.value,2))
    end
    if tokens != [] do
      {tokens,statement}
    else
      {[{:error,"",elem(nexTok,2)}],nil}
    end
  end

  def parseExp(tokens) do
    #IO.puts("ParseExp")
    # <parseLogicalAndExp> { || <parseLogicalAndExp>}
    {tokens,term} = parseLogicalAndExp(tokens);
    while_parse(tokens,term,[:orT],:parseLogicalAndExp)
  end

  def parseLogicalAndExp(tokens) do
    # <parseEqualityExp> { && <parseEqualityExp>}
    {tokens,term} = parseEqualityExp(tokens);
    while_parse(tokens,term,[:andT],:parseEqualityExp)
  end


  def parseEqualityExp(tokens) do
    # <relational-exp> { != | == <relational-exp>}
    {tokens,term} = parseRelationalExp(tokens);
    while_parse(tokens,term,[:equal, :notEqual],:parseRelationalExp)
  end


  def parseRelationalExp(tokens) do
    # <additive-exp> { <|>|>=|<= <additive-exp>}
    {tokens,term} = parseAdditiveExp(tokens);
    while_parse(tokens,term,[:lessThan, :greaterThan, :greaterThanEq, :lessThanEq],:parseAdditiveExp)
  end

  def parseAdditiveExp(tokens) do
    # <term> { (+ | - ) <term> }
    {tokens,term} = parseTerm(tokens);
    while_parse(tokens,term,[:addition,:negation_minus],:parseTerm)
  end

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
          IO.inspect(head)
          IO.inspect(nextToken)
          {tokens,nextTerm} = parseRelationalExp(tokens)
          IO.inspect(nextTerm)
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

  def parseTerm(tokens) do
    #<factor> {( * | / )  <factor>}
    {tokens,factor} = parseFactor(tokens);
    while_parse(tokens,factor,[:multiplication,:division],:parseFactor)
  end

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
          raise "Syntax Error close paren"
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
        raise "Syntax Error Unary operator or constant keyword expected at line " <> Integer.to_string(elem(nexTok,2))
    end
  end
  def check_unary_op(currToken) do
    if currToken == :negation_minus or currToken == :bitwiseN or currToken == :logicalN do
      True
    else
      False
    end
  end
end

