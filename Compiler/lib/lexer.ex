defmodule Lexer do
  def sanitize(rawText) do
    re = ~r/\n|\r|\t/
    #sanitized = Regex.replace(re,rawText,"")
    sanitized = String.trim(rawText)
    String.split(sanitized)

  end
  def tokensRemaining(sentence,token,char) do
    listTokens = [token]
    partialSentence = Regex.replace(char,sentence,"")
    #Partial fix to intmain or return2
    if String.first(partialSentence) do
      if token == Token.returnKeyword or token == Token.intKeyword  do
        IO.inspect partialSentence
        if String.first(partialSentence) != " "  do
          raise "Syntax Error " <> sentence
        end
      end
    end
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
        #Get the integer in String
        [number] = Regex.run(~r/^\d{1,}/,sentence)
        #IO.inspect number
        #Try to cast the string into integer
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

  def lexer(rawText) do
    listFormat = sanitize(rawText)
    listTokens = Enum.map(listFormat,&getTokens/1)
    listTokens = Enum.concat(listTokens)
  end
end




