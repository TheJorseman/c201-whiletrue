defmodule Lexer do
  def sanitize() do
    rawText = "



    int main(){
    return 60;
    }

    "
    re = ~r/\n|\r|\t/
    sanitized = Regex.replace(re,rawText,"")
    sanitized = String.trim(sanitized)
    IO.inspect sanitized
    String.split(sanitized)
  end
  def tokensRemaining(sentence,token,char) do
    listTokens = [token]
    IO.inspect listTokens
    partialSentence = Regex.replace(char,sentence,"")
    #Bug or something :(
    IO.puts partialSentence
    listTokens = listTokens ++ getTokens(partialSentence)
  end
  def getTokens(sentence) do
    cond do
      String.match?(sentence,~r/^{/) ->
        tokensRemaining(sentence,Token.openBrace(),~r/^{/)
      String.match?(sentence,~r/^}/) ->
        tokensRemaining(sentence,Token.closeBrace(),~r/^}/)
      String.match?(sentence,~r/^[(]/) ->
        tokensRemaining(sentence,Token.openParen(),~r/^[(]/)
      String.match?(sentence,~r/^[)]/) ->
        tokensRemaining(sentence,Token.closeParen(),~r/^[)]/)
      String.match?(sentence,~r/^int/) ->
        tokensRemaining(sentence,Token.intKeyword(),~r/^int/)
      String.match?(sentence,~r/^return/) ->
        tokensRemaining(sentence,Token.returnKeyword(),~r/^return/)
      String.match?(sentence,~r/^\d{1,}/) ->
        [number] = Regex.run(~r/^\d{1,}/,sentence)
        IO.inspect number
        value = String.to_integer(number)
        tokensRemaining(sentence,Token.constant(value),~r/^\d{1,}/)
      String.match?(sentence,~r/^main/) ->
        tokensRemaining(sentence,Token.identifier("main"),~r/^main/)
      String.match?(sentence,~r/^;/) ->
        tokensRemaining(sentence,Token.semicolon(),~r/^;/)
      sentence == "" -> []
      true -> raise "Syntax Error"
    end
  end

  def lexer() do
    listFormat = sanitize()
    IO.inspect listFormat
    listTokens = Enum.map(listFormat,&getTokens/1)
    listTokens = Enum.concat(listTokens)
    IO.inspect listTokens
    #** (ArgumentError) argument error
    #IO.puts listTokens
  end
end



