defmodule Lexer do
  def sanitize(rawText) do
    str_list = String.split(rawText,"\n")
    list = Enum.with_index(str_list)
    list = Enum.filter(list,fn(x)-> elem(x,0) != "" end)
    Enum.map(list,fn x -> {Regex.replace(~r/^\t+|\n+|\r+/,elem(x,0),""), elem(x,1) + 1} end)
  end
  def tokensRemaining(data,token,char) do
    listTokens = [token]
    sentence = elem(data,0)
    partialSentence = Regex.replace(char,sentence,"")
    partialSentence = String.trim(partialSentence)
    listTokens ++ getTokens({partialSentence,elem(data,1)})
  end
  def getTokens(data) do
    IO.inspect(data)
    sentence = elem(data,0)
    number_line = elem(data,1)
    cond do
      String.match?(sentence,~r/^{/) ->
        tokensRemaining(data,Token.openBrace(number_line),~r/^{/)
      String.match?(sentence,~r/^}/) ->
        tokensRemaining(data,Token.closeBrace(number_line),~r/^}/)
      String.match?(sentence,~r/^[(]/) ->
        tokensRemaining(data,Token.openParen(number_line),~r/^[(]/)
      String.match?(sentence,~r/^[)]/) ->
        tokensRemaining(data,Token.closeParen(number_line),~r/^[)]/)
      String.match?(sentence,~r/^int /) ->
        tokensRemaining(data,Token.intKeyword(number_line),~r/^int /)
      String.match?(sentence,~r/^return /) ->
        tokensRemaining(data,Token.returnKeyword(number_line),~r/^return /)
      String.match?(sentence,~r/^\d{1,}/) ->
        #Get the integer in String
        [number] = Regex.run(~r/^\d{1,}/,sentence)
        #Try to cast the string into integer
        value = String.to_integer(number)
        tokensRemaining(data,Token.constant(value,number_line),~r/^\d{1,}/)
      String.match?(sentence,~r/^main/) ->
        tokensRemaining(data,Token.identifier("main",number_line),~r/^main/)
      String.match?(sentence,~r/^;/) ->
        tokensRemaining(data,Token.semicolon(number_line),~r/^;/)
      String.match?(sentence,~r/^-/) ->
        tokensRemaining(data,Token.negation(number_line),~r/^-/)
      String.match?(sentence,~r/^~/) ->
        tokensRemaining(data,Token.bitwiseN(number_line),~r/^~/)
      String.match?(sentence,~r/^!/) ->
        tokensRemaining(data,Token.logicalN(number_line),~r/^!/)
      sentence == "" -> []
      sentence == " "-> []
      true ->
        error = "Unexpected Token " <> sentence <> " at line " <> Integer.to_string(number_line)
        raise error
        #IO.inspect(sentence)
        #[{:error,"Error 1: Unexpected Token" <> ssentence <> "at line " <> Integer.to_string(number_line) }]
    end
  end

  def lexer(rawText) do
    listFormat = sanitize(rawText)
    #IO.inspect(listFormat)
    listTokens = Enum.flat_map(listFormat,&getTokens/1)
    IO.inspect(listTokens)
  end
end




