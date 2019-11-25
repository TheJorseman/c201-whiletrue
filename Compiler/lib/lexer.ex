defmodule Lexer do
  @moduledoc """
  Este modulo convierte un string a una lista de tokens para el
  proceso de compilacion de un archivo en C.
  """
  @moduledoc since: "1.5.0"
  @doc """
  sanitize

  Elimina saltos de linea y obtiene la linea en la cual está.
  ## Parameters:
    rawText : Texto sin formatear.
  """
  def sanitize(rawText) do
    str_list = String.split(rawText,"\n")
    list = Enum.with_index(str_list)
    list = Enum.filter(list,fn(x)-> elem(x,0) != "" end)
    Enum.map(list,fn x -> {String.trim(Regex.replace(~r/^\t+|\n+|\r+/,elem(x,0),"")), elem(x,1) + 1} end)
  end
  @doc """
  def tokensRemaining
  Esta funcion sirve para agregar a una lista el token reconocido
  y posteriormente mandar de manera recursiva los otros elementos
  del string por ejemplo int main() reconoce int y manda a llamar a la funcion
  para que reconozca main() etc.

  ## Parametros:
    -data: Es el string entrante
    -token: Corresponde al token con el que se hizo match
    -char: Corresponde a la expresion regular para reemplazar con la cadena original

  """
  def tokensRemaining(data,token,char) do
    listTokens = [token]
    sentence = elem(data,0)
    partialSentence = Regex.replace(char,sentence,"")
    check_spaces(token,partialSentence)
    partialSentence = String.trim(partialSentence)
    listTokens ++ getTokens({partialSentence,elem(data,1)})
  end
  @doc """
  check_spaces
  Esta funcion revisa los espacios del string entrante y correspondiente
  a los tokens int y return para evitar errores como intmain o return2
  ## Parámetros
    -token    : Corresponde al token previamente reconocido.
    -sentence : Es el string sin el token reconocido.
  """
  def check_spaces(token,sentence) do
    tokens_space = [:intKeyword,:returnKeyword]
    valid = [nil," ","\n"]
    {name,_,line} = token
    if name in tokens_space do
      check = String.first(sentence)
      if not (check in valid) do
        raise "Unexpected " <> Atom.to_string(name) <> " Token at line " <> Integer.to_string(line)
      end
    end
  end
  @doc """
  getTokens

  Esta funcion recibe una tuplacon la sentencia y el numero de linea y regresa un error
  o una lista de tokens que reconocio.

  ## Parámetros
    -data : Tupla con el siguiente formato {linea,numero de linea}
            donde linea corresponde por ejemplo a int main() y linea es 2
  """
  def getTokens(data) do
    #IO.inspect(data)
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
      String.match?(sentence,~r/^int/) ->
        tokensRemaining(data,Token.intKeyword(number_line),~r/^int/)
      String.match?(sentence,~r/^return/) ->
        tokensRemaining(data,Token.returnKeyword(number_line),~r/^return/)
      String.match?(sentence,~r/^\d{1,}/) ->
        #Get the integer in String
        [number] = Regex.run(~r/^\d{1,}/,sentence)
        #Try to cast the string into integer
        value = String.to_integer(number)
        tokensRemaining(data,Token.constant(value,number_line),~r/^\d{1,}/)
      String.match?(sentence,~r/^[a-zA-Z]\w*/)->
        [[name]] = Regex.scan(~r/^[a-zA-Z]\w*/,sentence)
        tokensRemaining(data,Token.identifier(name,number_line),~r/^[a-zA-Z]\w*/)
      String.match?(sentence,~r/^;/) ->
        tokensRemaining(data,Token.semicolon(number_line),~r/^;/)
      String.match?(sentence,~r/^!=/) ->
        tokensRemaining(data,Token.notEqual(number_line),~r/^!=/)
      String.match?(sentence,~r/^-/) ->
        tokensRemaining(data,Token.negation_minus(number_line),~r/^-/)
      String.match?(sentence,~r/^~/) ->
        tokensRemaining(data,Token.bitwiseN(number_line),~r/^~/)
      String.match?(sentence,~r/^!/) ->
        tokensRemaining(data,Token.logicalN(number_line),~r/^!/)
      String.match?(sentence,~r/^\+/) ->
        tokensRemaining(data,Token.addition(number_line),~r/^\+/)
      String.match?(sentence,~r/^\*/) ->
        tokensRemaining(data,Token.multiplication(number_line),~r/\*/)
      String.match?(sentence,~r/^\//) ->
        tokensRemaining(data,Token.division(number_line),~r/^\//)
      String.match?(sentence,~r/^&&/) ->
        tokensRemaining(data,Token.andT(number_line),~r/^&&/)
      String.match?(sentence,~r/^\|\|/) ->
        tokensRemaining(data,Token.orT(number_line),~r/^\|\|/)
      String.match?(sentence,~r/^==/) ->
        tokensRemaining(data,Token.equal(number_line),~r/^==/)
      String.match?(sentence,~r/^<=/) ->
        tokensRemaining(data,Token.lessThanEq(number_line),~r/^<=/)
      String.match?(sentence,~r/^</) ->
        tokensRemaining(data,Token.lessThan(number_line),~r/^</)
      String.match?(sentence,~r/^>=/) ->
        tokensRemaining(data,Token.greaterThanEq(number_line),~r/^>=/)
      String.match?(sentence,~r/^>/) ->
        tokensRemaining(data,Token.greaterThan(number_line),~r/^>/)
      String.match?(sentence,~r/^=/) ->
        tokensRemaining(data,Token.assignment(number_line),~r/^=/)
      sentence == "" -> []
      sentence == " "-> []
      true ->
        error = "Unexpected Token " <> sentence <> " at line " <> Integer.to_string(number_line)
        raise error
        #IO.inspect(sentence)
        #[{:error,"Error 1: Unexpected Token" <> ssentence <> "at line " <> Integer.to_string(number_line) }]
    end
  end
  @doc """
  lexer
  Recibe el texto sin formato y devuelve una lista con tokens reconocidos. Es la funcion
  principal del Lexer.

  ## Parámetros
    -rawText : Corresponde con el texto que se obtiene de un archivo.
  """
  def lexer(rawText) do
    listFormat = sanitize(rawText)
    Enum.flat_map(listFormat,&getTokens/1)
  end
end
