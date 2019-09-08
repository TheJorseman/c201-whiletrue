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

  @spec returnKeyword(integer) :: token
  def returnKeyword(value), do: {:returnKeyword, value}

  @spec intKeyword(String.t) :: token
  def intKeyword(value), do: {:intKeyword, value}

end

defmodule Lexer do
  def sanitize() do
    rawText = "



    int main () {

    return 2;

    }

    "
    re = ~r/\n|\r|\t|\s{2,}/
    sanitized = Regex.replace(re,rawText,"")
    String.split(sanitized)
  end

  def getTokens(sentence) do

    if sentence == "" do
      []
    end

    cond do
      String.match?(sentence,~r/^{/) -> Token.openBrace()
      String.match?(sentence,~r/^}/) -> Token.closeBrace()
      true -> "buebos"
    end
  end

  def lexer() do
    listFormat = sanitize()
    listTokens = Enum.map(listFormat,&getTokens/1)
    IO.puts(listTokens)
  end
end



