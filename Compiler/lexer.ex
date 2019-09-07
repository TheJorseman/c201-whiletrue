defmodule Lexer do

    # Tokens (A darle atomos prros) (Ay papantla tus hijos vuelan)
  :openParen
  :closeParen
  :openBrace
  :closeBrace
  :returnKeyword
  :intKeyword
  :semicolon
  @type identifier :: String.t()
  @type constant :: integer()

  def sanitize(rawText) do
    rawText = "



    int main () {

    return 2;

    }

    "
    re = ~r/\n|\r|\t|\s{2,}/
    sanitized = Regex.replace(re,rawText,"")
    IO.puts(sanitized)
    ret_sanitized =  String.split(sanitized,' ')
  end

  def getTokens(sentences) do
    if sentences == [] do
      []
      #raise "Valio Brga que no esta viendo?"
    end
    firstSentence = List.first(sentences)
    case firstSentence do
      :openParen when String.includes(firstSentence,"")
    end



  end

  def lexer(rawText) do
    listFormat = sanitize(rawText)
    listTokens = getTokens(listFormat)
  end
end



