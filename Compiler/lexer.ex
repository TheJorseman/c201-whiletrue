defmodule Lexer do

  def sanitize(rawText) do
    rawText = "



    int main () {

    return 2;

    }

    "
    re = ~r/\n|\r|\t|\s{2,}/
    sanitized = Regex.replace(re,rawText,"")
    IO.puts(sanitized)
  end
end

