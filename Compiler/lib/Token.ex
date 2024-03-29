defmodule Token do
  @moduledoc """
  Este módulo es para definir los tokens que se van a utilizar en todo
  el proceso.
  """
  @moduledoc since: "1.5.0"
  @doc """
  Define los tokens que se van a utilizar dando un entero que se refiere a
  la linea donde se encuentra dicha expresion para ser utilizada posteriormente}
  en el manejo de errores.

  """

  @type token :: {atom, any(),integer}

  @spec openParen(integer) :: token
  def openParen(line), do: {:openParen, "(",line}

  @spec closeParen(integer) :: token
  def closeParen(line), do: {:closeParen, ")",line}

  @spec openBrace(integer) :: token
  def openBrace(line), do: {:openBrace, "{",line}

  @spec closeBrace(integer) :: token
  def closeBrace(line), do: {:closeBrace, "}",line}

  @spec semicolon(integer) :: token
  def semicolon(line), do: {:semicolon, ";",line}

  @spec returnKeyword(integer) :: token
  def returnKeyword(line), do: {:returnKeyword,"return",line}

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

  @spec andT(integer) :: token
  def andT(line), do: {:andT,"&&",line}

  @spec orT(integer) :: token
  def orT(line), do: {:orT,"||",line}

  @spec equal(integer) :: token
  def equal(line), do: {:equal,"==",line}

  @spec notEqual(integer) :: token
  def notEqual(line), do: {:notEqual,"!=",line}

  @spec lessThan(integer) :: token
  def lessThan(line), do: {:lessThan,"<",line}

  @spec lessThanEq(integer) :: token
  def lessThanEq(line), do: {:lessThanEq,"<=",line}

  @spec greaterThan(integer) :: token
  def greaterThan(line), do: {:greaterThan,">",line}

  @spec greaterThanEq(integer) :: token
  def greaterThanEq(line), do: {:greaterThanEq,">=",line}

  @spec assignment(integer) :: token
  def assignment(line), do: {:assignment,"=",line}
end
