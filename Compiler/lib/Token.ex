defmodule Token do
  @type token :: {atom, any(),integer}

  @spec openParen(integer) :: token
  def openParen(line), do: {:openParen, "",line}

  @spec closeParen(integer) :: token
  def closeParen(line), do: {:closeParen, "",line}

  @spec openBrace(integer) :: token
  def openBrace(line), do: {:openBrace, "",line}

  @spec closeBrace(integer) :: token
  def closeBrace(line), do: {:closeBrace, "",line}

  @spec semicolon(integer) :: token
  def semicolon(line), do: {:semicolon, "",line}

  @spec returnKeyword(integer) :: token
  def returnKeyword(line), do: {:returnKeyword,"",line}

  @spec identifier(String.t,integer) :: token
  def identifier(value,line), do: {:identifier,value,line}

  @spec constant(integer,integer) :: token
  def constant(value,line), do: {:constant,value,line}

  @spec intKeyword(integer) :: token
  def intKeyword(line), do: {:intKeyword,"int",line}

  @spec negation_minus(integer) :: token
  def negation_minus(line), do: {:negation_minus,"-",line}

  @spec bitwiseN(integer) :: token
  def bitwiseN(line), do: {:bitwiseN,"~",line}

  @spec logicalN(integer) :: token
  def logicalN(line), do: {:logicalN,"!",line}

  @spec addition(integer) :: token
  def addition(line), do: {:addition,"+",line}

  @spec multiplication(integer) :: token
  def multiplication(line), do: {:multiplication,"*",line}

  @spec division(integer) :: token
  def division(line), do: {:division,"/",line}

end
