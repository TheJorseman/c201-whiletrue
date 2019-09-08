defmodule Token do
  @type token :: {atom, any()}

  @spec openParen() :: token
  def openParen(), do: {:openParen, ""}

  @spec closeParen() :: token
  def closeParen(), do: {:closeParen, ""}

  @spec openBrace() :: token
  def openBrace(), do: {:openBrace, ""}

  @spec closeBrace() :: token
  def closeBrace(), do: {:closeBrace, ""}

  @spec semicolon() :: token
  def semicolon(), do: {:semicolon, ""}

  @spec returnKeyword() :: token
  def returnKeyword(), do: {:returnKeyword,""}

  @spec identifier(String.t) :: token
  def identifier(value), do: {:identifier,value}

  @spec constant(integer) :: token
  def constant(value), do: {:constant,value}

  @spec intKeyword() :: token
  def intKeyword(), do: {:intKeyword,""}

end
